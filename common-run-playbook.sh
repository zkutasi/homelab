CHECK=1
DIFF=1
LIMIT=
PLAYBOOK=

function usage()
{
  cat << EOF
./run-playbook.sh --playbook PLAYBOOKFILENAME [--no-diff] [--no-check]
EOF
}

while [ $# -ge 1 ]; do
  case "$1" in
    --playbook)
      shift
      PLAYBOOK=$1
      ;;
    --limit)
      shift
      LIMIT=$1
      ;;
    --no-diff)
      DIFF=0
      ;;
    --no-check)
      CHECK=0
      ;;
    *)
      echo "ERROR: unknown parameter \"$1\""
      usage
      exit 1
      ;;
  esac
  shift
done

[ -z "${PLAYBOOK}" ] && echo "ERROR: No playbook specified" && exit 1

REPO_ROOT=$(git rev-parse --show-toplevel)
export ANSIBLE_CONFIG="${REPO_ROOT}/automation/ansible/ansible.cfg"
CMD="ansible-playbook -i ${REPO_ROOT}/automation/ansible/inventory/hosts.yaml ${PLAYBOOK}"
[ "${CHECK}" -eq 1 ] && CMD="${CMD} --check"
[ "${DIFF}" -eq 1 ] && CMD="${CMD} --diff"
[ -n "${LIMIT}" ] && CMD="${CMD} --limit ${LIMIT}"

echo "Executing command: ${CMD}"
${CMD}
