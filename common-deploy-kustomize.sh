#!/bin/bash

NS=
FAILED=0
TEMPLATE=0
TEMPLATE_OUTPUT=

function usage() {
    echo "Usage: $0 --namespace <namespace> [--template] [--template-output <file>]"
    echo ""
    echo "Options:"
    echo "  --namespace <namespace>   Specify the Kubernetes namespace to deploy to (required)"
    echo "  --template                Print the rendered kustomization for testing, do not deploy"
    echo "  --template-output <file>  Like --template, but write the rendered YAML into the file instead of stdout"
}

function require_value() {
  if [ -z "$2" ] || [[ "$2" == --* ]]; then
    echo "ERROR: $1 needs a value"
    usage
    exit 1
  fi
}

while [ $# -ge 1 ]; do
  case "$1" in
    --namespace)
      require_value "$1" "$2"
      shift
      NS=$1
      ;;
    --template)
      TEMPLATE=1
      ;;
    --template-output)
      require_value "$1" "$2"
      shift
      TEMPLATE=1
      TEMPLATE_OUTPUT=$1
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

[ -z "${NS}" ] && echo "ERROR: No namespace specified" && exit 1

if [ "${TEMPLATE}" -eq 1 ]; then
  CMD=(kubectl kustomize .)
  echo "Executing command: ${CMD[*]}"
  if [ -n "${TEMPLATE_OUTPUT}" ]; then
    "${CMD[@]}" > "${TEMPLATE_OUTPUT}"
  else
    "${CMD[@]}"
  fi
  exit
fi

echo "Ensure namespace $NS exists..."
kubectl get namespace "$NS" >/dev/null 2>&1 || kubectl create namespace "$NS"

echo "Apply kustomization.yaml..."
CMD=(kubectl apply
    --kustomize .
    --namespace "$NS")

echo "Executing command: ${CMD[*]}"
if ! "${CMD[@]}"; then
  echo "ERROR: kubectl apply failed, not applying anything else"
  exit 1
fi

echo "Apply additional manifests, if any..."
if [ -d "./extra-manifests" ]; then
  while read -r line; do
    kubectl apply -f "$line" -n "$NS" || FAILED=1
  done < <(find ./extra-manifests -type f -name "*.yaml" | sort)
fi

exit "${FAILED}"
