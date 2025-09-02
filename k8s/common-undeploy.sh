DELETE_NAMESPACE=1
NS=
RELEASE_NAME=

while [ $# -ge 1 ]; do
  case "$1" in
    --delete-namespace)
      shift
      DELETE_NAMESPACE=$1
      ;;
    --namespace)
      shift
      NS=$1
      ;;
    --release-name)
      shift
      RELEASE_NAME=$1
      ;;
    *)
      echo "ERROR: unknown parameter \"$1\""
      usage
      exit 1
      ;;
  esac
  shift
done

[ -z "${NS}" ] && echo "ERROR: No namespace specified" && exit 1
[ -z "${RELEASE_NAME}" ] && echo "ERROR: No release name specified" && exit 1

echo "Uninstall helm chart..."
RELEASES=$(helm -n $NS list --short)
if echo "${RELEASES}" | grep -q "^${RELEASE_NAME}$"; then
  CMD="helm uninstall ${RELEASE_NAME} \
        --namespace $NS \
        --wait \
        --debug"

  echo "Executing command: ${CMD}"
  ${CMD}
else
  echo "Helm release ${RELEASE_NAME} not found in namespace ${NS}, skipping uninstall"
fi

if [ ${DELETE_NAMESPACE} -eq 1 ]; then
  echo "Deleting namespace ${NS}..."
  kubectl delete namespace $NS
fi
