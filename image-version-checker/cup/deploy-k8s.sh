#!/bin/bash

NS=cup

EXTRA_PARAMS=

while [ $# -ge 1 ]; do
  case "$1" in
    *)
      EXTRA_PARAMS="${EXTRA_PARAMS} $1"
      ;;
  esac
  shift
done

if [ ! -f 'cup.json' ]; then
  echo "No cup.json file found, creating and empty one"
  cat <<EOF > cup.json
{}
EOF
fi

$(git rev-parse --show-toplevel)/common-deploy-kompose.sh \
    --namespace $NS \
    ${EXTRA_PARAMS}
