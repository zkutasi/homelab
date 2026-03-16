#!/bin/bash

APP=tianji
CHART_NAME=msgbyte/tianji
NS=tianji
RELEASE_NAME=tianji
REPO_URL=https://msgbyte.github.io/charts

EXTRA_PARAMS=

while [ $# -ge 1 ]; do
  case "$1" in
    *)
      EXTRA_PARAMS="${EXTRA_PARAMS} $1"
      ;;
  esac
  shift
done

$(git rev-parse --show-toplevel)/common-deploy-cnpg.sh \
    --app-user ${APP} \
    --namespace $NS \
    ${EXTRA_PARAMS}

DB_PASSWORD=$(kubectl -n $NS get secret ${APP}-postgresql-db-password-secret -o jsonpath='{.data.password}' | base64 --decode)
yq eval ".postgresql.auth.password = \"${DB_PASSWORD}\"" -i app-values-private.yaml

JWT_SECRET=$(yq '.env.JWT_SECRET' app-values-private.yaml)
if [[ "${JWT_SECRET}" == "null" ]]; then
  JWT_SECRET=$(dd if=/dev/urandom bs=1 count=12 status=none | base64 | tr -dc 'a-zA-Z0-9' | head -c 12)
  yq -i ".env.JWT_SECRET=\"${JWT_SECRET}\"" app-values-private.yaml
fi

$(git rev-parse --show-toplevel)/common-deploy-helm.sh \
    --chart-name "${CHART_NAME}" \
    --namespace $NS \
    --release-name "${RELEASE_NAME}" \
    --repo-url "${REPO_URL}" \
    ${EXTRA_PARAMS}
