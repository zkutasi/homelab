#!/bin/bash

AGE_KEY=$(cat ${SOPS_AGE_KEY_FILE} | grep -oP "public key: \K(.*)")
ENCRYPT_FILE=""
MODE=decrypt-all
FILE_TYPE="binary"

function usage() {
    echo "Usage: $0 [--encrypt <file>] [--encrypt-all] [--decrypt <file>] [--decrypt-all] [--reencrypt-all]"
    echo ""
    echo "Options:"
    echo "  --encrypt <file>      Encrypt the specified file and save it as '<file>_encrypted'"
    echo "  --encrypt-all         Encrypt all files having 'private' in their name and save them as '<file>_encrypted'"
    echo "  --decrypt <file>      Decrypt the specified file (which should end with '_encrypted') and save it as '<file>'"
    echo "  --decrypt-all         Decrypt all files ending with '_encrypted' in the repository (default)"
    echo "  --reencrypt-all       Re-encrypt all encrypted files from their non-encrypted counterparts"
    echo ""
    echo "Environment Variables:"
    echo "  SOPS_AGE_KEY_FILE     Path to the file containing the age public key (required)"
}

while [ $# -ge 1 ]; do
  case "$1" in
    --decrypt)
        MODE=decrypt
        shift
        DECRYPT_FILE=$1
        ;;
    --decrypt-all)
        MODE=decrypt-all
        ;;
    --encrypt)
        MODE=encrypt
        shift
        ENCRYPT_FILE=$1
        ;;
    --encrypt-all)
        MODE=encrypt-all
        ;;
    --reencrypt-all)
        MODE=reencrypt-all
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
elif [ "${MODE}" == "decrypt" ]; then
    echo "Decrypting file: ${DECRYPT_FILE}..."
    if [[ ! "${DECRYPT_FILE}" == *_encrypted ]]; then
        echo "ERROR: file to decrypt must end with '_encrypted'"
        exit 1
    fi
    sops --decrypt \
        --input-type ${FILE_TYPE} \
        --output-type ${FILE_TYPE} \
        --age ${AGE_KEY} \
        --output "${DECRYPT_FILE%_encrypted}" \
        "${DECRYPT_FILE}"
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
elif [ "${MODE}" == "reencrypt-all" ]; then
    while read -r line; do
        decrypted_filename=${line%_encrypted}
        if [ -f "${decrypted_filename}" ]; then
            echo "Checking for changes in ${decrypted_filename} to re-encrypt..."
            diff -u <(sops --decrypt \
                --input-type ${FILE_TYPE} \
                --output-type ${FILE_TYPE} \
                --age ${AGE_KEY} \
                "${line}") \
                "${decrypted_filename}" >/dev/null
            res=$?
            if [ $res -eq 0 ]; then
                echo "No differences found. Skipping re-encryption for ${line}."
            elif [ $res -eq 1 ]; then
                echo "Differences found. Re-encrypting ${decrypted_filename} to ${line}..."
                sops --encrypt \
                    --input-type ${FILE_TYPE} \
                    --output-type ${FILE_TYPE} \
                    --age ${AGE_KEY} \
                    --output "${line}" \
                    "${decrypted_filename}"
            fi
        else
            echo "WARNING: Unencrypted file ${decrypted_filename} not found. Skipping re-encryption for ${line}."
        fi
    done < <(find $(git rev-parse --show-toplevel) -type f -name "*_encrypted")
elif [ "${MODE}" == "encrypt-all" ]; then
    while read -r line; do
        encrypted_filename=${line}_encrypted
        if [ -f "${encrypted_filename}" ]; then
            echo "Checking for changes in ${line} to re-encrypt..."
            diff -u <(sops --decrypt \
                --input-type ${FILE_TYPE} \
                --output-type ${FILE_TYPE} \
                --age ${AGE_KEY} \
                "${line}") \
                "${line}" >/dev/null
            res=$?
            if [ $res -eq 0 ]; then
                echo "No differences found. Skipping re-encryption for ${line}."
            elif [ $res -eq 1 ]; then
                echo "Differences found. Re-encrypting ${line} to ${encrypted_filename}..."
                sops --encrypt \
                    --input-type ${FILE_TYPE} \
                    --output-type ${FILE_TYPE} \
                    --age ${AGE_KEY} \
                    --output "${line}" \
                    "${line}"
            fi
        else
            sops --encrypt \
                --input-type ${FILE_TYPE} \
                --output-type ${FILE_TYPE} \
                --age ${AGE_KEY} \
                --output "${encrypted_filename}" \
                "${line}"
        fi
    done < <(find $(git rev-parse --show-toplevel) -type f -size +0c -name "*private*" ! -name "*_encrypted" ! -name "*.j2")
else
    echo "ERROR: unknown mode \"${MODE}\""
    exit 1
fi
