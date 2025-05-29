PLAYBOOK=
DIFF=1
CHECK=1

while [ $# -ge 1 ]; do
  case "$1" in
    --playbook)
      shift
      PLAYBOOK=$1
      ;;
    --no-diff)
      DIFF=0
      ;;
    ---no-check)
      CHECK=0
      ;;
  esac
  shift
done

[ -z "${PLAYBOOOK}" ] && echo "ERROR: No playbook specified" && exit 1

CMD=ansible-playbook -i inventory/hosts.yaml ${PLAYBOOK}
[ "${DIFF}" -eq 1 ] && CMD="${CMD} --diff"
[ "${CHECK}" -eq 1 ] && CMD="${CMD} --check"

${CMD}

