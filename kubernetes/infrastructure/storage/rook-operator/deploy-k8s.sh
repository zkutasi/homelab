CHART_NAME=rook-release/rook-ceph
NS=rook-ceph
RELEASE_NAME=rook-ceph
REPO_URL=https://charts.rook.io/release

EXTRA_PARAMS=

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
    --repo-url "${REPO_URL}" \
    ${EXTRA_PARAMS}
