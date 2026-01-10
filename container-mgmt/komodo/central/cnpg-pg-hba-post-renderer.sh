#!/bin/bash

set -euo pipefail

yq eval '
  (select(.kind == "Cluster") | .spec.postgresql.pg_hba) +=
    ["host all all all trust"]
' - > /dev/stdout
