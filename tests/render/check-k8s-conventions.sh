#!/bin/bash

function usage() {
    echo "Usage: $0 <work folder> <internal domain>"
    echo ""
    echo "Checks the Kubernetes App rules on the work folder of tests/render/render-k8s.sh: every App's extra manifests"
    echo "(repo/<App>/extra-manifests/*.yaml) and its render (out/<App with _ for />.yaml). Prints one tab-separated"
    echo "line per violation: App, object (kind/name), rule, detail. Prints nothing when everything follows the rules."
    echo ""
    echo "Rules:"
    echo "  namespace        an extra manifest sets metadata.namespace (the deploy helper supplies it)"
    echo "  static-file      an HTTPProxy or Certificate lives in a static file instead of a generated -private one"
    echo "  fqdn             an HTTPProxy's virtual host isn't below the internal domain"
    echo "  tls-secret       an HTTPProxy's TLS secret isn't the secret of a Certificate of the same App"
    echo "  health-endpoint  an object names its own health path in the homelab/health-endpoint annotation"
    echo ""
    echo "Options:"
    echo "  --help    Display this help message"
}

WORK_DIR=
DOMAIN=
while [ $# -ge 1 ]; do
  case "$1" in
    --help)
      usage
      exit 0
      ;;
    --*)
      echo "ERROR: unknown parameter \"$1\""
      usage
      exit 1
      ;;
    *)
      if [ -z "${WORK_DIR}" ]; then
        WORK_DIR=$1
      elif [ -z "${DOMAIN}" ]; then
        DOMAIN=$1
      else
        echo "ERROR: too many arguments"
        usage
        exit 1
      fi
      ;;
  esac
  shift
done
if [ -z "${WORK_DIR}" ] || [ -z "${DOMAIN}" ] || [ ! -d "${WORK_DIR}/repo" ]; then
  echo "ERROR: a work folder of render-k8s.sh and the internal domain are needed"
  usage
  exit 1
fi

# Every object of every App, one JSON line each: the App, the file (relative to the App), whether it is an extra
# manifest, and the object itself
REPO="${WORK_DIR}/repo"
{
  while IFS= read -r -d '' FILE; do
    RELATIVE=${FILE#"${REPO}"/}
    export APP=${RELATIVE%%/extra-manifests/*}
    export IN_APP=${RELATIVE#"${APP}"/}
    yq ea -o=json -I=0 'select(. != null) | {"app": strenv(APP), "file": strenv(IN_APP), "extra": true, "obj": .}' "${FILE}"
  done < <(find "${REPO}" -path '*/extra-manifests/*' -type f -name '*.yaml' -print0 | sort -z)
  while IFS= read -r WRAPPER; do
    export APP=${WRAPPER#"${REPO}"/}
    APP=${APP%/deploy-k8s.sh}
    RENDER="${WORK_DIR}/out/${APP//\//_}.yaml"
    [ -f "${RENDER}" ] || continue
    yq ea -o=json -I=0 'select(. != null) | {"app": strenv(APP), "file": "(render)", "extra": false, "obj": .}' "${RENDER}"
  done < <(find "${REPO}" -name deploy-k8s.sh | sort)
} | jq -s -r --arg domain "${DOMAIN}" '
  (map(select(.obj.kind == "Certificate")) | group_by(.app) | map({(.[0].app): map(.obj.spec.secretName)}) | add // {}) as $certs
  | .[] | . as $o | ($o.obj.kind + "/" + ($o.obj.metadata.name // "?")) as $id
  | (
      (select($o.extra and ($o.obj.metadata.namespace // null) != null)
        | [$o.app, $id, "namespace", $o.file + ": " + $o.obj.metadata.namespace]),
      (select($o.extra and ($o.obj.kind == "HTTPProxy" or $o.obj.kind == "Certificate") and ($o.file | test("-private[.]yaml$") | not))
        | [$o.app, $id, "static-file", $o.file]),
      (select($o.obj.kind == "HTTPProxy" and $o.obj.spec.virtualhost != null)
        | ($o.obj.spec.virtualhost.fqdn // "") as $fqdn
        | (select($fqdn | endswith("." + $domain) | not) | [$o.app, $id, "fqdn", $fqdn]),
          (($o.obj.spec.virtualhost.tls.secretName // "") as $secret
            | select(($certs[$o.app] // []) | index($secret) | not)
            | [$o.app, $id, "tls-secret", if $secret == "" then "no TLS secret" else $secret end])),
      (select(($o.obj.metadata.annotations // {}) | has("homelab/health-endpoint"))
        | [$o.app, $id, "health-endpoint", $o.obj.metadata.annotations["homelab/health-endpoint"]])
    )
  | @tsv'
