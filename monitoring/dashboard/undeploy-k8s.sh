NS=kubernetes-dashboard
RELEASE_NAME=kubernetes-dashboard

EXTRA_PARAMS=""

while [ $# -ge 1 ]; do
  case "$1" in
    *)
      EXTRA_PARAMS="${EXTRA_PARAMS} $1"
      ;;
  esac
  shift
done

$(git rev-parse --show-toplevel)/common-undeploy-helm.sh \
    --namespace $NS \
    --release-name "${RELEASE_NAME}" \
    ${EXTRA_PARAMS}

kubectl delete clusterrolebinding kube-ds-viewer-role-binding
kubectl delete clusterrolebinding kube-ds-editor-role-binding
kubectl delete clusterrolebinding kube-ds-admin-role-binding
