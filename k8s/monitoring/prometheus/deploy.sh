NS=monitoring
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

helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
    --version ${VERSION} \
    --namespace $NS \
    --create-namespace \
    --values app-values.yaml \
    --values app-values-private.yaml \
    --debug

kubectl apply -f prometheus/prometheus-internal-certificate.yaml
kubectl apply -f prometheus/prometheus-httpproxy.yaml
kubectl apply -f prometheus/grafana-internal-certificate.yaml
kubectl apply -f prometheus/grafana-httpproxy.yaml
