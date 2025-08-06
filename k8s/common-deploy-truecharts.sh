APP=
CHART_NAME=
NS=
RELEASE_NAME=
VERSION=

while [ $# -ge 1 ]; do
  case "$1" in
    --app)
      shift
      APP=$1
      ;;
    --chart-name)
      shift
      CHART_NAME=$1
      ;;
    --namespace)
      shift
      NS=$1
      ;;
    --release-name)
      shift
      RELEASE_NAME=$1
      ;;
    --version)
      shift
      VERSION=$1
      ;;
    *)
      echo "ERROR: unknown parameter \"$1\""
      usage
      exit 1
      ;;
  esac
  shift
done

[ -z "${APP}" ] && echo "APP must be set" && exit 1
[ -z "${CHART_NAME}" ] && CHART_NAME=oci://tccr.io/truecharts/${APP}
[ -z "${NS}" ] && NS=${APP}
[ -z "${RELEASE_NAME}" ] && RELEASE_NAME=${APP}

if [ -z "${VERSION}" ]; then
  echo "Trying to figure out the latest version..."
  CURL_CHART_REPO=${CHART_NAME/oci/https}
  CURL_CHART_REPO=${CURL_CHART_REPO/tccr.io/tccr.io\/v2}
  latest=$(curl -s ${CURL_CHART_REPO}/tags/list | jq -r '.tags[]' | sort -V | tail -n1)
  echo "Latest version is ${latest}"
  VERSION=${latest}
fi

echo "Install helm chart..."
CMD="helm upgrade --install ${RELEASE_NAME} ${CHART_NAME} \
    --version ${VERSION} \
    --namespace $NS \
    --create-namespace \
    --values app-values.yaml \
    --values app-values-private.yaml \
    --debug"

echo "Executing command: ${CMD}"
${CMD}

echo "Apply additional manifests, if any..."
if [ -d "./extra-manifests" ]; then
  while read -r line; do
    kubectl apply -f "$line" -n $NS
  done < <(find ./extra-manifests -type f -name "*.yaml")
fi
