#!/bin/bash

NS=speedtest-tracker
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

if ! $(kubectl -n $NS get secret speedtest-tracker-db-password-secret &> /dev/null); then
  echo "Generating random database password..."
  DB_PASSWORD="$(dd if=/dev/urandom bs=1 count=12 status=none | base64 | tr -dc 'a-zA-Z0-9' | head -c 12)"

  kubectl create namespace $NS
  kubectl create secret generic speedtest-tracker-db-password-secret \
      --from-literal=username=speedtest_tracker \
      --from-literal=password="${DB_PASSWORD}" \
      --type=kubernetes.io/basic-auth \
      --namespace=$NS
fi
DB_PASSWORD=$(kubectl get secret -n $NS speedtest-tracker-db-password-secret -o jsonpath='{.data.password}' | base64 -d)

echo "Deploying the PostgreSQL database..."
$(git rev-parse --show-toplevel)/common-deploy-helm.sh \
    --chart-name cnpg/cluster \
    --release-name postgresql \
    --namespace $NS \
    --repo-url ${REPO_URL_CNPG} \
    --app postgresql-cluster \
    ${EXTRA_PARAMS}

if grep -q "^DB_PASSWORD=" .speedtest.env; then
  sed -i "s|^DB_PASSWORD=.*|DB_PASSWORD=${DB_PASSWORD}|" .speedtest.env
else
  echo "DB_PASSWORD=${DB_PASSWORD}" >> .speedtest.env
fi

$(git rev-parse --show-toplevel)/common-deploy-kompose.sh \
    --namespace $NS \
    ${EXTRA_PARAMS}
