# shellcheck shell=bash
# Shared setup for the bats tests: the assertion libraries, a throwaway repository per test and stub commands.
# Load it with `load helpers` (or `load ../helpers` from a sub-folder) and call setup_fake_repo in setup().

bats_load_library bats-support
bats_load_library bats-assert

# The real repository, mounted read-only; scripts under test are copied from here into the fake repository
REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)

# Creates the fake repository (a folder with an empty .git marker) and puts the stub folder first on PATH,
# with the git stub in it. Stubs log their calls, one line each, into STUB_LOG.
function setup_fake_repo() {
  FAKE_REPO="${BATS_TEST_TMPDIR}/repo"
  STUB_DIR="${BATS_TEST_TMPDIR}/stubs"
  STUB_LOG="${BATS_TEST_TMPDIR}/stub-calls.log"
  mkdir -p "${FAKE_REPO}/.git" "${STUB_DIR}"
  : > "${STUB_LOG}"
  cp "${REPO_ROOT}/tests/bats/stubs/git" "${STUB_DIR}/git"
  PATH="${STUB_DIR}:${PATH}"
}

# copy_into_repo <path>...: copies files of the real repository to the same paths in the fake one
function copy_into_repo() {
  local file
  for file in "$@"; do
    mkdir -p "${FAKE_REPO}/$(dirname "${file}")"
    cp -p "${REPO_ROOT}/${file}" "${FAKE_REPO}/${file}"
  done
}

# write_stub <path> [exit code] [output]: an executable that logs one line into STUB_LOG, its name followed by
# its arguments shell-quoted (so "two words" is logged as two\ words), prints the output (if any) and exits
# with the code (default 0). With STUB_ENV_VARS set to variable names, it also logs "NAME=value" (or
# "NAME unset") lines for them, after the call line.
function write_stub() {
  local path=$1 rc=${2:-0} output=${3:-} var
  mkdir -p "$(dirname "${path}")"
  {
    echo '#!/bin/bash'
    echo "{ printf '%s' $(basename "${path}"); [ \$# -gt 0 ] && printf ' %q' \"\$@\"; echo; } >> \"${STUB_LOG}\""
    for var in ${STUB_ENV_VARS:-}; do
      echo "if [ -n \"\${${var}+set}\" ]; then echo \"${var}=\${${var}}\"; else echo \"${var} unset\"; fi >> \"${STUB_LOG}\""
    done
    [ -n "${output}" ] && printf 'echo %q\n' "${output}"
    echo "exit ${rc}"
  } > "${path}"
  chmod +x "${path}"
}

# make_stub <command> [exit code] [output]: a stub command on PATH
function make_stub() {
  write_stub "${STUB_DIR}/$1" "${2:-0}" "${3:-}"
}

# assert_stub_called <line>: the stub log holds exactly this line
function assert_stub_called() {
  run grep -Fx -- "$1" "${STUB_LOG}"
  assert_success
}

# assert_stub_not_called <command>: no logged call of this command
function assert_stub_not_called() {
  run grep -E -- "^$1( |$)" "${STUB_LOG}"
  assert_failure
}
