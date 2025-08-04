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
    --values app-values-private.yaml \
    --debug

kubectl apply -f httpproxy.yaml -n $NS
kubectl apply -f internal-certificate.yaml -n $NS

kubectl create sa kube-ds-viewer -n $NS
kubectl create sa kube-ds-editor -n $NS
kubectl create sa kube-ds-admin -n $NS

kubectl create clusterrolebinding kube-ds-viewer-role-binding --clusterrole=view --user=system:serviceaccount:$NS:kube-ds-viewer
kubectl create clusterrolebinding kube-ds-editor-role-binding --clusterrole=edit --user=system:serviceaccount:$NS:kube-ds-editor
kubectl create clusterrolebinding kube-ds-admin-role-binding --clusterrole=admin --user=system:serviceaccount:$NS:kube-ds-admin

kubectl create token kube-ds-viewer -n $NS
kubectl create token kube-ds-editor -n $NS
kubectl create token kube-ds-admin -n $NS
