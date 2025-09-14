NS=komodo
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

if ! $(kubectl -n $NS get secret komodo-db-password-secret &> /dev/null); then
  echo "Generating random database password..."
  DB_PASSWORD="$(dd if=/dev/urandom bs=1 count=12 status=none | base64 | tr -dc 'a-zA-Z0-9' | head -c 12)"

  kubectl create namespace $NS
  kubectl create secret generic komodo-db-password-secret \
      --from-literal=username=komodo \
      --from-literal=password="${DB_PASSWORD}" \
      --type=kubernetes.io/basic-auth \
      --namespace=$NS
fi
DB_PASSWORD=$(kubectl get secret -n $NS komodo-db-password-secret -o jsonpath='{.data.password}' | base64 -d)

echo "Deploying the PostgreSQL database..."
$(git rev-parse --show-toplevel)/common-deploy-helm.sh \
    --chart-name cnpg/cluster \
    --release-name postgresql \
    --namespace $NS \
    --repo-url ${REPO_URL_CNPG} \
    --app postgresql-cluster \
    ${EXTRA_PARAMS}

echo "Setting up environment files with private data..."
cat <<EOF > .ferret.env
FERRETDB_POSTGRESQL_URL=postgres://komodo:${DB_PASSWORD}@postgresql-cluster-rw:5432/komodo
EOF
if grep -q "^KOMODO_DATABASE_URI=" .komodo.env; then
  sed -i "s|^KOMODO_DATABASE_URI=.*|KOMODO_DATABASE_URI=mongodb://komodo:${DB_PASSWORD}@ferretdb:27017/komodo|" .komodo.env
else
  echo "KOMODO_DATABASE_URI=mongodb://komodo:${DB_PASSWORD}@ferretdb:27017/komodo" >> .komodo.env
fi
if grep -q "^KOMODO_DATABASE_PASSWORD=" .komodo.env; then
  sed -i "s|^KOMODO_DATABASE_PASSWORD=.*|KOMODO_DATABASE_PASSWORD=${DB_PASSWORD}|" .komodo.env
else
  echo "KOMODO_DATABASE_PASSWORD=${DB_PASSWORD}" >> .komodo.env
fi

$(git rev-parse --show-toplevel)/common-deploy-kompose.sh \
    --namespace $NS \
    ${EXTRA_PARAMS}
