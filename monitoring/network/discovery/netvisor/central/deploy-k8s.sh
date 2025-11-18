#!/bin/bash

APP=netvisor
NS=netvisor
RELEASE_NAME=netvisor
REPO_URL_CNPG=https://cloudnative-pg.github.io/charts

EXTRA_PARAMS=

while [ $# -ge 1 ]; do
  case "$1" in
    *)
      EXTRA_PARAMS="${EXTRA_PARAMS} $1"
      ;;
  esac
  shift
done

DB_SECRET_NAME="${APP}-db-password-secret"
DB_USERNAME="netvisor"
DB_HOST="postgresql-cluster-rw"
DB_DATABASE="netvisor"
if ! $(kubectl -n $NS get secret ${DB_SECRET_NAME} &> /dev/null); then
  echo "Generating random database password..."
  DB_PASSWORD="$(dd if=/dev/urandom bs=1 count=12 status=none | base64 | tr -dc 'a-zA-Z0-9' | head -c 12)"

  kubectl create namespace $NS
  kubectl create secret generic ${DB_SECRET_NAME} \
      --from-literal=username="${DB_USERNAME}" \
      --from-literal=password="${DB_PASSWORD}" \
      --type=kubernetes.io/basic-auth \
      --namespace=$NS
fi
DB_PASSWORD=$(kubectl get secret -n $NS ${DB_SECRET_NAME} -o jsonpath='{.data.password}' | base64 -d)
DB_CONNECTION_STRING="postgresql://${DB_USERNAME}:${DB_PASSWORD}@${DB_HOST}:5432/${DB_DATABASE}"
yq -i ".secret.db-credentials.data.database-url=\"${DB_CONNECTION_STRING}\"" app-values-private.yaml

echo "Deploying the PostgreSQL database..."
$(git rev-parse --show-toplevel)/common-deploy-helm.sh \
    --chart-name cnpg/cluster \
    --release-name postgresql \
    --namespace $NS \
    --repo-url ${REPO_URL_CNPG} \
    --app postgresql-cluster \
    ${EXTRA_PARAMS}

$(git rev-parse --show-toplevel)/common-deploy-helm.sh \
    --chart-name ${PWD}/chart \
    --namespace $NS \
    --release-name "${RELEASE_NAME}" \
    --type local \
    ${EXTRA_PARAMS}
