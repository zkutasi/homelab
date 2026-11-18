#!/bin/bash

function usage() {
    echo "Usage: $0 [--source <inventory folder>]"
    echo ""
    echo "Writes tests/render/inventory: the private inventory's groups, variable names and structure, with dummy values"
    echo "and generic host names (host01, host02, ...), for the render tests. Rerun it after inventory changes, and review"
    echo "the result before committing: Jinja expressions are kept as they are."
    echo ""
    echo "Options:"
    echo "  --help                Display this help message"
    echo "  --source <folder>     The private inventory folder (default: automation/ansible/homelab-ansible-inventory/inventory)"
}

function require_value() {
  if [ -z "$2" ] || [[ "$2" == --* ]]; then
    echo "ERROR: $1 needs a value"
    usage
    exit 1
  fi
}

REPO_ROOT=$(git rev-parse --show-toplevel)
SOURCE="${REPO_ROOT}/automation/ansible/homelab-ansible-inventory/inventory"
while [ $# -ge 1 ]; do
  case "$1" in
    --help)
      usage
      exit 0
      ;;
    --source)
      require_value "$1" "$2"
      shift
      SOURCE=$1
      ;;
    *)
      echo "ERROR: unknown parameter \"$1\""
      usage
      exit 1
      ;;
  esac
  shift
done

if [ ! -f "${SOURCE}/hosts.yaml" ]; then
  echo "ERROR: No inventory found at ${SOURCE}"
  exit 1
fi
TARGET="${REPO_ROOT}/tests/render/inventory"

# Each string gets a dummy derived from its own path (key names, list indexes), keeping only its shape: an IP
# stays an IP, a URL a URL, and so on. Jinja expressions stay as they are. yq has no if/else, so every rule is a
# pass over the strings it applies to; the last pass catches everything no earlier pass produced. Numbers and
# booleans stay (ports, IDs, flags), except numbers under secret-like keys.
# yq has neither if/else nor def: STRS (the strings, Jinja expressions excluded) and NAME (a string's own path)
# are spliced into the expression instead. NAME uses hyphens only, as dummies end up in DNS names, which can't hold an
# underscore.
STRS='(.. | select(tag == "!!str" and (test("[{][{]") | not)))'
NAME='(path | map(tostring) | join("-") | downcase | sub("_"; "-"))'
DUMMY="
  (${STRS} | select(test(\"^[0-9]{1,3}([.][0-9]{1,3}){3}/[0-9]+$\"))) = \"192.0.2.0/24\" |
  (${STRS} | select(test(\"^[0-9]{1,3}([.][0-9]{1,3}){3}$\"))) = \"192.0.2.10\" |
  (${STRS} | select(test(\"^[0-9a-fA-F]*:[0-9a-fA-F:]*(/[0-9]+)?$\") and test(\":.*:\"))) = \"fd00:db8::/64\" |
  (${STRS} | select(test(\"^https?://\"))) |= \"https://\" + ${NAME} + \".example.com\" |
  (${STRS} | select(test(\"^[^/@ ]+@[^@ /]+$\") and (test(\"example[.]com$\") | not))) |= ${NAME} + \"@example.com\" |
  (${STRS} | select(test(\"^/\"))) |= \"/srv/\" + ${NAME} |
  (${STRS} | select(test(\"^[A-Za-z0-9-]+([.][A-Za-z0-9-]+)+$\") and test(\"[A-Za-z]\") and (test(\"example[.]com$\") | not))) |= ${NAME} + \".example.com\" |
  (${STRS} | select(test(\"^(192[.]0[.]2[.]|fd00:db8::|https://|/srv/)|example[.]com$\") | not)) |= ${NAME} |
  (.. | select(tag == \"!!int\" and (path | .[-1] | tostring | test(\"(?i)pass|secret|token|key|pin|chat\")))) = 1234 |
  (.. | select(tag == \"!!str\" and test(\"[{][{]\"))) |= (
      sub(\"@[A-Za-z0-9.-]+[.][A-Za-z]+\", \"@example.com\")
    | sub(\"[0-9]{1,3}([.][0-9]{1,3}){3}\", \"192.0.2.10\")
    | sub(\"([A-Za-z0-9-]+[.])+(home|lan|local|net|com|org|io|de|hu)\\\\b\", \"example.com\"))
"

# Generic host names, numbered in sorted order of the real ones; the mapping isn't kept anywhere. Map keys and
# strings that name a real host (a dictionary keyed by host, a host in a mount option) get the generic name too.
HOST_MAP=$(yq -o=json -I=0 '[.. | select(has("hosts")) | .hosts | keys | .[]] | unique
    | to_entries | map({(.value): ("host" + ((.key + 1) | tostring | sub("^(.)$", "0${1}")))}) | .[] as $item ireduce ({}; . * $item)' \
    "${SOURCE}/hosts.yaml")
RENAME_HOSTS='env(HOST_MAP) as $map | (.. | select(tag == "!!map")) |= with_entries(.key |= ($map[.] // .))'
while read -r REAL GENERIC; do
  RENAME_HOSTS+=" | (.. | select(tag == \"!!str\")) |= sub(\"\\\\b${REAL//./[.]}\\\\b\", \"${GENERIC}\")"
done < <(yq -r 'to_entries | .[] | .key + " " + .value' <<< "${HOST_MAP}")

function convert() {
  HOST_MAP="${HOST_MAP}" yq "${RENAME_HOSTS} | ${DUMMY}" "$1"
}

rm -rf "${TARGET}"
mkdir -p "${TARGET}/group_vars/all"
for FILE in "${SOURCE}"/group_vars/*; do
  NAME=$(basename "${FILE}")
  OUT="${TARGET}/group_vars/${NAME}.yaml"
  # group_vars/all is a folder here, so the hand-written facts.yaml can sit next to the generated variables
  [ "${NAME}" = "all" ] && OUT="${TARGET}/group_vars/all/inventory.yaml"
  if ! convert "${FILE}" > "${OUT}"; then
    echo "ERROR: Could not convert ${FILE}"
    exit 1
  fi
done
if ! convert "${SOURCE}/hosts.yaml" > "${TARGET}/hosts.yaml"; then
  echo "ERROR: Could not convert ${SOURCE}/hosts.yaml"
  exit 1
fi
cp "${REPO_ROOT}/tests/render/facts.yaml" "${TARGET}/group_vars/all/facts.yaml"
cp "${REPO_ROOT}/tests/render/runtime.yaml" "${TARGET}/group_vars/all/runtime.yaml"

echo "INFO: Wrote ${TARGET#"${REPO_ROOT}"/}: $(yq '[.. | select(has("hosts")) | .hosts | keys | .[]] | unique | length' "${TARGET}/hosts.yaml") hosts, $(cat "${TARGET}"/group_vars/*.yaml "${TARGET}"/group_vars/all/inventory.yaml | yq -N 'keys | .[]' | wc -l) group variables"
echo "INFO: Kept Jinja expressions (review them before committing): $(grep -rhc '{{' "${TARGET}" | paste -sd+ | bc)"
