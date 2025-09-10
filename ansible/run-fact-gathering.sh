if [ $# -lt 1 ]; then echo "Usage: $0 HOST"; exit 1; fi
HOST=$1

ansible ${HOST} -i inventory/hosts.yaml -m setup
