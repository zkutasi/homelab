CHART_NAME=librenms/librenms
NS=librenms
RELEASE_NAME=librenms

EXTRA_PARAMS="--post-renderer kustomize.sh"

while [ $# -ge 1 ]; do
  case "$1" in
    *)
      EXTRA_PARAMS="${EXTRA_PARAMS} $1"
      ;;
  esac
  shift
done

$(git rev-parse --show-toplevel)/common-deploy-helm.sh \
    --chart-name "${CHART_NAME}" \
    --namespace $NS \
    --release-name "${RELEASE_NAME}" \
    ${EXTRA_PARAMS}
