#!/bin/bash

REPO_URL_CNPG=https://cloudnative-pg.github.io/charts
# renovate: datasource=helm depName=cluster registryUrl=https://cloudnative-pg.github.io/charts
CNPG_CLUSTER_CHART_VERSION=0.8.1

APP=app-postgresql
DB_DATABASE=app
DB_USERNAME=app
DB_PASSWORD=
NS=${APP}
RELEASE_NAME=postgresql

EXTRA_PARAMS=

while [ $# -ge 1 ]; do
  case "$1" in
    --app)
      shift
      APP=$1
      NS=${APP}
      ;;
    --db-database)
      shift
      DB_DATABASE=$1
      ;;
    --db-username)
      shift
      DB_USERNAME=$1
      ;;
    --db-password)
      shift
      DB_PASSWORD=$1
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
      EXTRA_PARAMS="${EXTRA_PARAMS} $1"
      ;;
  esac
  shift
done

DB_SECRET_NAME="${APP}-db-password-secret"
DB_USERNAME=${DB_USERNAME}
DB_DATABASE=${DB_DATABASE}
if ! $(kubectl -n "$NS" get secret "${DB_SECRET_NAME}" &> /dev/null); then
  if [ -z "${DB_PASSWORD}" ]; then
    echo "Generating random database password..."
    DB_PASSWORD="$(dd if=/dev/urandom bs=1 count=12 status=none | base64 | tr -dc 'a-zA-Z0-9' | head -c 12)"
  fi

  kubectl get namespace "$NS" >/dev/null 2>&1 || kubectl create namespace "$NS"
  kubectl create secret generic "${DB_SECRET_NAME}" \
      --from-literal=username="${DB_USERNAME}" \
      --from-literal=password="${DB_PASSWORD}" \
      --type=kubernetes.io/basic-auth \
      --namespace="$NS"
fi

echo "Setting the database initialization values..."
touch app-postgresql-values-private.yaml
yq -i ".cluster.initdb.database=\"${DB_DATABASE}\"" app-postgresql-values-private.yaml
yq -i ".cluster.initdb.owner=\"${DB_USERNAME}\"" app-postgresql-values-private.yaml
yq -i ".cluster.initdb.secret.name=\"${DB_SECRET_NAME}\"" app-postgresql-values-private.yaml

echo "Deploying the PostgreSQL database..."
"$(git rev-parse --show-toplevel)"/common-deploy-helm.sh \
    --chart-name cnpg/cluster \
    --release-name "${RELEASE_NAME}" \
    --namespace "$NS" \
    --repo-url ${REPO_URL_CNPG} \
    --version "${CNPG_CLUSTER_CHART_VERSION}" \
    --app app-postgresql \
    --no-extra-manifests \
    ${EXTRA_PARAMS}
