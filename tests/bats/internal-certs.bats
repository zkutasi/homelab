#!/usr/bin/env bats
# security/certificates/internal-certs.sh: creates the internal CA in ./certs, never over an existing one. It runs
# on a copy of the script with openssl stubbed, so no key is created and the real CA is never read.
# covers: security/certificates/internal-certs.sh

load helpers

CERTS=security/certificates

setup() {
  setup_fake_repo
  copy_into_repo "${CERTS}/internal-certs.sh"
  make_stub openssl
  WORK="${BATS_TEST_TMPDIR}/work"
  mkdir -p "${WORK}" && cd "${WORK}" || exit 1
}

@test "in an empty folder it creates the key, then a CA certificate valid for 30 years" {
  run "${FAKE_REPO}/${CERTS}/internal-certs.sh"
  assert_success
  assert [ -d certs ]
  assert_stub_calls \
    "openssl genrsa -out certs/ca.key 4096" \
    "openssl req -new -x509 -sha256 -days 10950 -key certs/ca.key -out certs/ca.crt"
}

@test "it refuses when a CA key or certificate already exists" {
  local file
  for file in ca.key ca.crt; do
    rm -rf certs && mkdir certs && touch "certs/${file}"
    run "${FAKE_REPO}/${CERTS}/internal-certs.sh"
    assert_failure 1
    assert_output --partial "ERROR: A CA already exists in certs"
  done
  assert_stub_not_called openssl
}

@test "it refuses options" {
  run "${FAKE_REPO}/${CERTS}/internal-certs.sh" --force
  assert_failure 1
  assert_line 'ERROR: unknown parameter "--force"'
  assert_stub_not_called openssl
}
