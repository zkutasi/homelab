NS=cnpg-system
RELEASE_NAME=cnpg

EXTRA_PARAMS=""

while [ $# -ge 1 ]; do
  case "$1" in
    *)
      EXTRA_PARAMS="${EXTRA_PARAMS} $1"
      ;;
  esac
  shift
done

CLUSTERS=$(kubectl get clusters.postgresql.cnpg.io \
    --all-namespaces \
    -o go-template \
    --template='{{range .items}}{{.metadata.namespace}}/{{.metadata.name}}{{"\n"}}{{end}}')

if [ -n "$CLUSTERS" ]; then
  echo "The following PostgreSQL clusters exist and must be deleted before uninstalling the operator:"
  echo "$CLUSTERS"
  exit 1
fi

$(git rev-parse --show-toplevel)/k8s/common-undeploy.sh \
    --namespace $NS \
    --release-name "${RELEASE_NAME}" \
    ${EXTRA_PARAMS}
