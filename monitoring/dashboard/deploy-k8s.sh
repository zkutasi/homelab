CHART_NAME=kubernetes-dashboard/kubernetes-dashboard
NS=kubernetes-dashboard
RELEASE_NAME=kubernetes-dashboard
REPO_URL=https://kubernetes.github.io/dashboard/

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

kubectl create sa kube-ds-viewer -n $NS
kubectl create sa kube-ds-editor -n $NS
kubectl create sa kube-ds-admin -n $NS

kubectl create clusterrolebinding kube-ds-viewer-role-binding --clusterrole=view --user=system:serviceaccount:$NS:kube-ds-viewer
kubectl create clusterrolebinding kube-ds-editor-role-binding --clusterrole=edit --user=system:serviceaccount:$NS:kube-ds-editor
kubectl create clusterrolebinding kube-ds-admin-role-binding --clusterrole=admin --user=system:serviceaccount:$NS:kube-ds-admin

kubectl create token kube-ds-viewer -n $NS
kubectl create token kube-ds-editor -n $NS
kubectl create token kube-ds-admin -n $NS
