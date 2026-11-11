#!/bin/bash

function usage() {
    echo "Usage: $0"
    echo ""
    echo "Generates a new internal CA (ca.key, ca.crt) in ./certs, refuses if one exists. Takes no options."
}

while [ $# -ge 1 ]; do
  case "$1" in
    --help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: unknown parameter \"$1\""
      usage
      exit 1
      ;;
  esac
  shift
done

OUTPUT_DIR=certs
VALID_FOR_YEARS=30
VALID_FOR_DAYS=$((VALID_FOR_YEARS * 365))

if [ -f "${OUTPUT_DIR}/ca.key" ] || [ -f "${OUTPUT_DIR}/ca.crt" ]; then
  echo "ERROR: A CA already exists in ${OUTPUT_DIR}, delete ca.key and ca.crt first to replace it"
  exit 1
fi

mkdir -p ${OUTPUT_DIR}

openssl genrsa -out ${OUTPUT_DIR}/ca.key 4096
openssl req -new -x509 -sha256 -days ${VALID_FOR_DAYS} -key ${OUTPUT_DIR}/ca.key -out ${OUTPUT_DIR}/ca.crt
