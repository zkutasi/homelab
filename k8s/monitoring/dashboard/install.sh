NS=kubernetes-dashboard
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

[ -z "${VERSION}" ] && echo "ERROR: No version specified" && exit 1

helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard \
    --version ${VERSION} \
    --namespace $NS \
    --create-namespace \
    --values app-values.yaml \
    --debug
