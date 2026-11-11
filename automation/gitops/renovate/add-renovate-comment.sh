#!/bin/bash

function usage() {
    echo "Usage: $0"
    echo ""
    echo "Adds a '# renovate: image=...' comment above appVersion in every Chart.yaml whose values files name exactly one image repository. Takes no options."
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

ROOT_DIR=$(git rev-parse --show-toplevel)

while read -r chart; do
    echo "Handling ${chart}..."

    grep -q "renovate: image=" "${chart}" && echo "Renovate comment already exists in ${chart}, skipping..." && continue

    echo "trying to find the image for ${chart}..."
    base_dir="${chart%/chart/Chart.yaml}"
    mapfile -t images < <(
        grep -r --no-filename --include='*-values.yaml' 'repository:' "${base_dir}" | awk '{print $NF}' | sort -u
    )

    case ${#images[@]} in
        0)
            echo "INFO: No repository found for ${chart}, skipping..."
            continue
            ;;
        1)
            image="${images[0]}"
            ;;
        *)
            echo "WARN: Multiple repository entries found for ${chart}, skipping..."
            echo "  ${images[*]}"
            continue
            ;;
    esac
    echo "Found image ${image} for ${chart}"

    echo "Adding renovate comment to ${chart}..."
    sed -i "/^appVersion:/i # renovate: image=${image}" "${chart}"

    echo "=========="
done < <(find "${ROOT_DIR}" -name Chart.yaml)
