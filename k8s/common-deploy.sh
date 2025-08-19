CHART_NAME=
LATEST=0
NS=
RELEASE_NAME=
VERSION=

while [ $# -ge 1 ]; do
  case "$1" in
    --chart-name)
      shift
      CHART_NAME=$1
      ;;
    --latest)
      LATEST=1
      ;;
    --namespace)
      shift
      NS=$1
      ;;
    --release-name)
      shift
      RELEASE_NAME=$1
      ;;
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

if [ -z "${VERSION}" ] && [ $LATEST -eq 0 ]; then
  echo "Trying to figure out the current version..."
  current=$(helm -n $NS get metadata ${RELEASE_NAME} | grep ^VERSION | awk '{print $NF}')
  if [ -n "${current}" ]; then
    echo "Current version is ${current}"
    VERSION=${current}
  else
    echo "No current version found."
  fi
fi
if [ -z "${VERSION}" ]; then
  echo "Trying to figure out the latest version..."
  latest=$(helm search repo --regexp "\v${CHART_NAME}\v" | tail -n1 | awk '{print $2}')
  echo "Latest version is ${latest}"
  VERSION=${latest}
fi

[ -z "${CHART_NAME}" ] && echo "ERROR: No chart name specified" && exit 1
[ -z "${NS}" ] && echo "ERROR: No namespace specified" && exit 1
[ -z "${RELEASE_NAME}" ] && echo "ERROR: No release name specified" && exit 1
[ -z "${VERSION}" ] && echo "ERROR: No version specified" && exit 1

echo "Install helm chart..."
CMD="helm upgrade --install ${RELEASE_NAME} ${CHART_NAME} \
    --version ${VERSION} \
    --namespace $NS \
    --create-namespace \
    --values app-values.yaml \
    --values app-values-private.yaml \
    --debug"

echo "Executing command: ${CMD}"
${CMD}

echo "Apply additional manifests, if any..."
if [ -d "./extra-manifests" ]; then
  while read -r line; do
    kubectl apply -f "$line" -n $NS
  done < <(find ./extra-manifests -type f -name "*.yaml")
fi
