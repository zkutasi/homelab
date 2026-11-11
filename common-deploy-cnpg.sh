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
TEMPLATE=0

EXTRA_PARAMS=

function usage() {
    echo "Usage: $0 [--app <app-name>] [--namespace <namespace>] [--release-name <release-name>] [--db-database <name>] [--db-username <name>] [--db-password <password>] [--template] [--debug]"
    echo ""
    echo "Options:"
    echo "  --app <app-name>            Name of the database App, also the default namespace (default: app-postgresql)"
    echo "  --namespace <namespace>     Kubernetes namespace to deploy to (default: the App name)"
    echo "  --release-name <name>       Helm release name of the database cluster (default: postgresql)"
    echo "  --db-database <name>        Database to create (default: app)"
    echo "  --db-username <name>        Owner of the database (default: app)"
    echo "  --db-password <password>    Password of the owner, used only when its secret doesn't exist yet (default: random)"
    echo "  --template                  Only template out the database chart: no namespace, secret or values file is created, nothing is deployed"
    echo "  --debug                     Passed on to common-deploy-helm.sh: pass --debug to helm"
    echo "  --help                      Show this help"
    echo ""
    echo "Any other option is ignored, so a calling App can pass its own options on unchanged."
}

function require_value() {
  if [ -z "$2" ] || [[ "$2" == --* ]]; then
    echo "ERROR: $1 needs a value"
    usage
    exit 1
  fi
}

while [ $# -ge 1 ]; do
  case "$1" in
    --app)
      require_value "$1" "$2"
      shift
      APP=$1
      NS=${APP}
      ;;
    --db-database)
      require_value "$1" "$2"
      shift
      DB_DATABASE=$1
      ;;
    --db-username)
      require_value "$1" "$2"
      shift
      DB_USERNAME=$1
      ;;
    --db-password)
      require_value "$1" "$2"
      shift
      DB_PASSWORD=$1
      ;;
    --namespace)
      require_value "$1" "$2"
      shift
      NS=$1
      ;;
    --release-name)
      require_value "$1" "$2"
      shift
      RELEASE_NAME=$1
      ;;
    --help)
      usage
      exit 0
      ;;
    --template)
      TEMPLATE=1
      ;;
    --debug)
      EXTRA_PARAMS="${EXTRA_PARAMS} $1"
      ;;
    *)
      echo "INFO: Ignoring ${1} for the database chart"
      ;;
  esac
  shift
done

DB_SECRET_NAME="${APP}-db-password-secret"
DB_USERNAME=${DB_USERNAME}
DB_DATABASE=${DB_DATABASE}
if [ "${TEMPLATE}" -eq 0 ]; then
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
fi

TEMPLATE_ARGS=
[ "${TEMPLATE}" -eq 1 ] && TEMPLATE_ARGS="--template"

echo "Deploying the PostgreSQL database..."
"$(git rev-parse --show-toplevel)"/common-deploy-helm.sh \
    --chart-name cnpg/cluster \
    --release-name "${RELEASE_NAME}" \
    --namespace "$NS" \
    --repo-url ${REPO_URL_CNPG} \
    --version "${CNPG_CLUSTER_CHART_VERSION}" \
    --app app-postgresql \
    --no-extra-manifests \
    ${TEMPLATE_ARGS} \
    ${EXTRA_PARAMS}
