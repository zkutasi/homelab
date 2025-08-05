CHART_NAME=metallb/metallb
NS=metallb-system
RELEASE_NAME=metallb
VERSION=

while [ $# -ge 1 ]; do
  case "$1" in
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

$(git rev-parse --show-toplevel)/k8s/common-deploy.sh \
    --chart-name "${CHART_NAME}" \
    --namespace $NS \
    --release-name "${RELEASE_NAME}" \
    --version "${VERSION}"
