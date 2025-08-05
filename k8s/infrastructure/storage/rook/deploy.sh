NS=rook-ceph
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

helm upgrade --install rook-ceph rook-release/rook-ceph \
    --version ${VERSION} \
    --namespace $NS \
    --create-namespace \
    --values app-operator-values.yaml \
    --values app-operator-values-private.yaml \
    --debug

helm upgrade --install rook-ceph-cluster rook-release/rook-ceph-cluster \
    --version ${VERSION} \
    --namespace $NS \
    --create-namespace \
    --values app-cluster-values.yaml \
    --values app-cluster-values-private.yaml \
    --debug

kubectl apply -f toolbox.yaml -n $NS
kubectl apply -f dashboard-httpproxy.yaml -n $NS
kubectl apply -f dashboard-internal-certificate.yaml -n $NS
