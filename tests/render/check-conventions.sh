#!/bin/bash

function usage() {
    echo "Usage: $0 <render output folder>"
    echo ""
    echo "Checks the README's Docker App rules on rendered compose files: for every <App>/normalized.json (docker compose"
    echo "config --format json) with its <App>/expected.json, prints one tab-separated line per violation:"
    echo "App, service, rule, detail. Prints nothing when everything follows the rules."
    echo ""
    echo "Options:"
    echo "  --help    Display this help message"
}

OUT_DIR=
while [ $# -ge 1 ]; do
  case "$1" in
    --help)
      usage
      exit 0
      ;;
    --*)
      echo "ERROR: unknown parameter \"$1\""
      usage
      exit 1
      ;;
    *)
      OUT_DIR=$1
      ;;
  esac
  shift
done
if [ -z "${OUT_DIR}" ] || [ ! -d "${OUT_DIR}" ]; then
  echo "ERROR: The render output folder is required"
  usage
  exit 1
fi

# The rules, per service (see "Docker Apps" in the README):
#   container_name  set
#   hostname        <id>-<container_name>
#   restart         unless-stopped
#   TZ              in the environment
#   image           one of the App's requested_image_version entries
#   mount           no bind mount into another App's folder below docker_compose_rootdir
#   pull_policy     an image without a tag or digest is always pulled
RULES='
  .expected as $e | .compose.services | to_entries[] | .key as $s | .value as $v |
  [
    (if ($v.container_name // "") == "" then ["container_name", "missing"] else empty end),
    (if $v.hostname != ($e.id + "-" + ($v.container_name // "")) then ["hostname", (($v.hostname // "missing") + ", expected " + $e.id + "-" + ($v.container_name // "<container_name>"))] else empty end),
    (if $v.restart != "unless-stopped" then ["restart", ($v.restart // "missing")] else empty end),
    (if ($v.environment // {} | has("TZ")) | not then ["TZ", "missing"] else empty end),
    (if ($e.images | to_entries | map(.value) | index($v.image)) == null
     then ["image", (($v.image // "none") + " is not pinned in requested_image_version")] else empty end),
    (($v.volumes // [])[] | select(.type == "bind"
        and (.source | startswith($e.rootdir + "/"))
        and ((.source == $e.rootdir + "/" + $e.project) or (.source | startswith($e.rootdir + "/" + $e.project + "/")) | not))
      | ["mount", (.source + " is in another App'"'"'s folder")]),
    (if ($v.image // "" | test(":[^/:]+$|@sha256:") | not) and ($v.pull_policy // "") != "always"
     then ["pull_policy", ("untagged image " + ($v.image // "none") + " without pull_policy: always")] else empty end)
  ][] | [$app, $s] + . | @tsv
'

find "${OUT_DIR}" -name normalized.json | sort | while read -r NORMALIZED; do
  APP_DIR=$(dirname "${NORMALIZED}")
  jq -n -r --arg app "${APP_DIR#"${OUT_DIR}"/}" \
      --slurpfile compose "${NORMALIZED}" --slurpfile expected "${APP_DIR}/expected.json" \
      "{compose: \$compose[0], expected: \$expected[0]} | ${RULES}"
done
