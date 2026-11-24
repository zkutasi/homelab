#!/bin/bash
# Builds fake Python packages as wheels for the pipx scenarios, which install them with PIP_NO_INDEX and PIP_FIND_LINKS:
# /srv/pipx/current holds fake-tool 1.0.0 and fake-plugin 1.0.0, /srv/pipx/next fake-tool 2.0.0
set -e
WORK=$(mktemp -d)

# wheel <folder> <package> <version> [<console script>]
function wheel() {
  local folder=$1 package=$2 version=$3 script=${4:-} module=${2//-/_}
  local dir="${WORK}/${package}-${version}" info="${module}-${version}.dist-info"
  mkdir -p "${dir}/${module}" "${dir}/${info}"
  printf 'VERSION = "%s"\n\n\ndef main():\n    print(VERSION)\n' "${version}" > "${dir}/${module}/__init__.py"
  printf 'Metadata-Version: 2.1\nName: %s\nVersion: %s\n' "${package}" "${version}" > "${dir}/${info}/METADATA"
  printf 'Wheel-Version: 1.0\nGenerator: tests\nRoot-Is-Purelib: true\nTag: py3-none-any\n' > "${dir}/${info}/WHEEL"
  [ -n "${script}" ] && printf '[console_scripts]\n%s = %s:main\n' "${script}" "${module}" > "${dir}/${info}/entry_points.txt"
  (cd "${dir}" && find . -type f -printf '%P,,\n' > "${info}/RECORD" && echo "${info}/RECORD,," >> "${info}/RECORD")
  mkdir -p "${folder}"
  (cd "${dir}" && python3 -m zipfile -c "${folder}/${module}-${version}-py3-none-any.whl" "${module}" "${info}")
}

wheel /srv/pipx/current fake-tool 1.0.0 fake-tool
wheel /srv/pipx/current fake-plugin 1.0.0
wheel /srv/pipx/next fake-tool 2.0.0 fake-tool
rm -rf "${WORK}"
