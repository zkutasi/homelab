#!/bin/bash

APP=gatus
VERSION=3.6.2

EXTRA_PARAMS="--extra-values gatus-values-config-private.yaml"

while [ $# -ge 1 ]; do
  case "$1" in
    *)
      EXTRA_PARAMS="${EXTRA_PARAMS} $1"
      ;;
  esac
  shift
done

DB_PASSWORD=$(yq '.cnpg.main.password' gatus-values-private.yaml)
if [[ "${DB_PASSWORD}" == "null" ]]; then
    DB_PASSWORD=$(dd if=/dev/urandom bs=1 count=12 status=none | base64 | tr -dc 'a-zA-Z0-9' | head -c 12)
    yq -i ".cnpg.main.password=\"${DB_PASSWORD}\"" gatus-values-private.yaml
fi

$(git rev-parse --show-toplevel)/common-ansible-run-playbook.sh \
    --playbook ${PWD}/generate-configuration.yaml \
    --no-check

sed -i "4a\\
        storage:\\
          type: postgres\\
          path: postgresql://gatus:${DB_PASSWORD}@gatus-cnpg-main-rw:5432/gatus?client_encoding=utf8" gatus-values-config-private.yaml

$(git rev-parse --show-toplevel)/common-deploy-helm.sh \
    --app "${APP}" \
    --type truecharts \
    --version "${VERSION}" \
    ${EXTRA_PARAMS}
