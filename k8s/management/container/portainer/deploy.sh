NS=portainer
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

helm upgrade --install portainer portainer/portainer \
    --version ${VERSION} \
    --namespace $NS \
    --create-namespace \
    --values app-values.yaml \
    --values app-values-private.yaml \
    --debug

kubectl apply -f httpproxy.yaml -n $NS
kubectl apply -f internal-certificate.yaml -n $NS
