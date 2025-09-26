#!/bin/bash

AGE_KEY=$(cat ${SOPS_AGE_KEY_FILE} | grep -oP "public key: \K(.*)")
ENCRYPT_FILE=""
MODE=decrypt-all
FILE_TYPE="binary"

function usage() {
    echo "Usage: $0 [--decrypt-all] [--encrypt <file>]"
    echo ""
    echo "Options:"
    echo "  --decrypt-all         Decrypt all files ending with '_encrypted' in the repository (default)"
    echo "  --encrypt <file>      Encrypt the specified file and save it as '<file>_encrypted'"
    echo ""
    echo "Environment Variables:"
    echo "  SOPS_AGE_KEY_FILE     Path to the file containing the age public key (required)"
}

while [ $# -ge 1 ]; do
  case "$1" in
    --decrypt-all)
        MODE=decrypt-all
        ;;
    --encrypt)
        MODE=encrypt
        shift
        ENCRYPT_FILE=$1
        ;;
    *)
      echo "ERROR: unknown parameter \"$1\""
      usage
      exit 1
      ;;
  esac
  shift
done

if [ "${MODE}" == "encrypt" ]; then
    echo "Encrypting file: ${ENCRYPT_FILE}..."
    sops --encrypt \
        --input-type ${FILE_TYPE} \
        --output-type ${FILE_TYPE} \
        --age ${AGE_KEY} \
        --output "${ENCRYPT_FILE}_encrypted" \
        "${ENCRYPT_FILE}"
elif [ "${MODE}" == "decrypt-all" ]; then
    while read -r line; do
        echo "Decrypting file: ${line}..."
        decrypted_filename=${line%_encrypted}
        if [ -f "${decrypted_filename}" ]; then
            echo "WARNING: Decrypted file ${decrypted_filename} already exists. Skipping decryption, but check the diff..."
            diff -u <(sops --decrypt \
                --input-type ${FILE_TYPE} \
                --output-type ${FILE_TYPE} \
                --age ${AGE_KEY} \
                "${line}") \
                "${decrypted_filename}"
            res=$?
            if [ $res -eq 0 ]; then
                echo "No differences found between decrypted content and existing file."
            elif [ $res -eq 1 ]; then
                echo "Differences found between decrypted content and existing file."
                exit 1
            fi
        else
            sops --decrypt \
                --input-type ${FILE_TYPE} \
                --output-type ${FILE_TYPE} \
                --age ${AGE_KEY} \
                --output "${decrypted_filename}" \
                "${line}"
        fi
    done < <(find $(git rev-parse --show-toplevel) -type f -name "*_encrypted")
else
    echo "ERROR: unknown mode \"${MODE}\""
    exit 1
fi
