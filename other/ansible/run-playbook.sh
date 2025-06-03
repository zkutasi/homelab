PLAYBOOK=
DIFF=1
CHECK=1

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

CMD="ansible-playbook -i inventory/hosts.yaml ${PLAYBOOK}"
[ "${DIFF}" -eq 1 ] && CMD="${CMD} --diff"
[ "${CHECK}" -eq 1 ] && CMD="${CMD} --check"

echo "Executing command: ${CMD}"
${CMD}

