#!/bin/bash

ENCRYPT_FILE=""
MODE=
FILE_TYPE="binary"
FAILED=0
MISMATCHES=()
TMP_DECRYPTED=$(mktemp)
trap 'rm -f "${TMP_DECRYPTED}"' EXIT

function usage() {
    echo "Usage: $0 [--encrypt <file> | --decrypt <file> | --encrypt-all | --decrypt-all | --reencrypt-all | --redecrypt-all | --help]"
    echo ""
    echo "Options:"
    echo "  --encrypt <file>      Encrypt <file> and save it as '<file>_encrypted'"
    echo "  --decrypt <file>      Decrypt <file> (must end with '_encrypted') and save it without that suffix"
    echo "  --encrypt-all         Encrypt every file with 'private' in its name (except templates and '_encrypted' copies), skipping unchanged ones"
    echo "  --decrypt-all         Decrypt every '_encrypted' file whose plaintext is missing, and diff-check the existing ones (used by the pre-commit hook)"
    echo "  --reencrypt-all       Re-encrypt every '_encrypted' file whose plaintext has changed"
    echo "  --redecrypt-all       Overwrite every plaintext file with the decrypted content of its '_encrypted' copy"
    echo "  --help                Show this help"
    echo ""
    echo "Environment Variables:"
    echo "  SOPS_AGE_KEY_FILE     Path to your age private key file (required); its public key, derived with age-keygen, is the recipient"
}

function require_value() {
  if [ -z "$2" ] || [[ "$2" == --* ]]; then
    echo "ERROR: $1 needs a value"
    usage
    exit 1
  fi
}

function sops_encrypt() {
    # Encrypt plaintext file $1 into $2
    local plain_file=$1
    local encrypted_file=$2
    sops --encrypt \
        --input-type ${FILE_TYPE} \
        --output-type ${FILE_TYPE} \
        --age "${AGE_KEY}" \
        --output "${encrypted_file}" \
        "${plain_file}" \
        || { echo "ERROR: Could not encrypt ${plain_file}"; FAILED=1; }
}

function sops_decrypt() {
    # Decrypt encrypted file $1 into plaintext file $2
    local encrypted_file=$1
    local plain_file=$2
    sops --decrypt \
        --input-type ${FILE_TYPE} \
        --output-type ${FILE_TYPE} \
        --age "${AGE_KEY}" \
        --output "${plain_file}" \
        "${encrypted_file}" \
        || { echo "ERROR: Could not decrypt ${encrypted_file}"; FAILED=1; }
}

function decrypt_to_tmp() {
    # Decrypt encrypted file $1 into TMP_DECRYPTED, to compare it with its plaintext
    local encrypted_file=$1
    if ! sops --decrypt \
        --input-type ${FILE_TYPE} \
        --output-type ${FILE_TYPE} \
        --age "${AGE_KEY}" \
        "${encrypted_file}" > "${TMP_DECRYPTED}"; then
        echo "ERROR: Could not decrypt ${encrypted_file}, skipping it"
        FAILED=1
        return 1
    fi
}

function reencrypt_if_changed() {
    # Re-encrypt plaintext file $1 into $2 if its content differs; $3 is the name reported when skipping
    local plain_file=$1
    local encrypted_file=$2
    local skipped_name=$3
    echo "Checking for changes in ${plain_file} to re-encrypt..."
    decrypt_to_tmp "${encrypted_file}" || return
    diff -u "${TMP_DECRYPTED}" "${plain_file}" >/dev/null
    res=$?
    if [ $res -eq 0 ]; then
        echo "No differences found. Skipping re-encryption for ${skipped_name}."
    elif [ $res -eq 1 ]; then
        echo "Differences found. Re-encrypting ${plain_file} to ${encrypted_file}..."
        sops_encrypt "${plain_file}" "${encrypted_file}"
    fi
}

while [ $# -ge 1 ]; do
  case "$1" in
    --decrypt)
        MODE=decrypt
        require_value "$1" "$2"
        shift
        DECRYPT_FILE=$1
        ;;
    --decrypt-all)
        MODE=decrypt-all
        ;;
    --encrypt)
        MODE=encrypt
        require_value "$1" "$2"
        shift
        ENCRYPT_FILE=$1
        ;;
    --encrypt-all)
        MODE=encrypt-all
        ;;
    --reencrypt-all)
        MODE=reencrypt-all
        ;;
    --redecrypt-all)
        MODE=redecrypt-all
        ;;
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

if [ -z "${MODE}" ]; then
  usage
  exit 1
fi

if [ -z "${SOPS_AGE_KEY_FILE}" ] || [ ! -f "${SOPS_AGE_KEY_FILE}" ]; then
  echo "ERROR: SOPS_AGE_KEY_FILE must point to your age key file (currently: \"${SOPS_AGE_KEY_FILE}\")"
  exit 1
fi
if ! command -v age-keygen >/dev/null 2>&1; then
  echo "ERROR: age-keygen is needed to derive the public key (see deploy-age.yaml)"
  exit 1
fi
AGE_KEY=$(age-keygen -y "${SOPS_AGE_KEY_FILE}" | paste -sd, -)
if [ -z "${AGE_KEY}" ]; then
  echo "ERROR: Could not derive the public key from ${SOPS_AGE_KEY_FILE}"
  exit 1
fi

if [ "${MODE}" == "encrypt" ]; then
    if [ -z "${ENCRYPT_FILE}" ] || [ ! -f "${ENCRYPT_FILE}" ]; then
        echo "ERROR: --encrypt needs an existing file (got \"${ENCRYPT_FILE}\")"
        exit 1
    fi
    if [[ "${ENCRYPT_FILE}" == *_encrypted ]]; then
        echo "ERROR: ${ENCRYPT_FILE} is already an encrypted file"
        exit 1
    fi
    echo "Encrypting file: ${ENCRYPT_FILE}..."
    sops_encrypt "${ENCRYPT_FILE}" "${ENCRYPT_FILE}_encrypted"
elif [ "${MODE}" == "decrypt" ]; then
    if [[ ! "${DECRYPT_FILE}" == *_encrypted ]]; then
        echo "ERROR: file to decrypt must end with '_encrypted'"
        exit 1
    fi
    if [ ! -f "${DECRYPT_FILE}" ]; then
        echo "ERROR: ${DECRYPT_FILE} does not exist"
        exit 1
    fi
    echo "Decrypting file: ${DECRYPT_FILE}..."
    sops_decrypt "${DECRYPT_FILE}" "${DECRYPT_FILE%_encrypted}"
elif [ "${MODE}" == "encrypt-all" ]; then
    while read -r line; do
        decrypted_filename=${line}
        encrypted_filename=${line}_encrypted
        if [ -f "${encrypted_filename}" ]; then
            reencrypt_if_changed "${decrypted_filename}" "${encrypted_filename}" "${decrypted_filename}"
        else
            echo "Encrypting file: ${decrypted_filename}..."
            sops_encrypt "${decrypted_filename}" "${encrypted_filename}"
        fi
    done < <(find "$(git rev-parse --show-toplevel)" -name .git -prune -o -type f -size +0c -name "*private*" ! -name "*_encrypted" ! -name "*.j2" -print)
elif [ "${MODE}" == "decrypt-all" ]; then
    while read -r line; do
        encrypted_filename=${line}
        decrypted_filename=${line%_encrypted}
        if [ -f "${decrypted_filename}" ]; then
            echo "WARNING: Decrypted file ${decrypted_filename} already exists. Skipping decryption, but check the diff..."
            decrypt_to_tmp "${encrypted_filename}" || continue
            diff -u "${TMP_DECRYPTED}" "${decrypted_filename}"
            res=$?
            if [ $res -eq 0 ]; then
                echo "No differences found between decrypted content and existing file."
            elif [ $res -eq 1 ]; then
                echo "Differences found between decrypted content and existing file."
                MISMATCHES+=("${decrypted_filename}")
                FAILED=1
            fi
        else
            echo "Decrypting file: ${encrypted_filename}..."
            sops_decrypt "${encrypted_filename}" "${decrypted_filename}"
        fi
    done < <(find "$(git rev-parse --show-toplevel)" -name .git -prune -o -type f -name "*_encrypted" -print)
elif [ "${MODE}" == "reencrypt-all" ]; then
    while read -r line; do
        encrypted_filename=${line}
        decrypted_filename=${line%_encrypted}
        if [ -f "${decrypted_filename}" ]; then
            reencrypt_if_changed "${decrypted_filename}" "${encrypted_filename}" "${encrypted_filename}"
        else
            echo "WARNING: Unencrypted file ${decrypted_filename} not found. Skipping re-encryption for ${encrypted_filename}."
        fi
    done < <(find "$(git rev-parse --show-toplevel)" -name .git -prune -o -type f -name "*_encrypted" -print)
elif [ "${MODE}" == "redecrypt-all" ]; then
    while read -r line; do
        encrypted_filename=${line}
        decrypted_filename=${line%_encrypted}
        echo "Decrypting file: ${encrypted_filename}..."
        sops_decrypt "${encrypted_filename}" "${decrypted_filename}"
    done < <(find "$(git rev-parse --show-toplevel)" -name .git -prune -o -type f -name "*_encrypted" -print)
else
    echo "ERROR: unknown mode \"${MODE}\""
    exit 1
fi

if [ ${#MISMATCHES[@]} -gt 0 ]; then
    echo "ERROR: ${#MISMATCHES[@]} decrypted file(s) differ from their encrypted copy:"
    printf '  %s\n' "${MISMATCHES[@]}"
fi

exit "${FAILED}"
