#!/usr/bin/env bats
# security/secret-mgmt/age-sops/sops.sh, as a component test with the real sops and age and a throwaway key
# covers: security/secret-mgmt/age-sops/sops.sh

load helpers

SOPS_SH=security/secret-mgmt/age-sops/sops.sh

setup() {
  command -v sops >/dev/null && command -v age-keygen >/dev/null || skip "sops and age-keygen are needed"
  setup_fake_repo
  copy_into_repo "${SOPS_SH}"
  SCRIPT="${FAKE_REPO}/${SOPS_SH}"
  export SOPS_AGE_KEY_FILE="${BATS_TEST_TMPDIR}/age.key"
  age-keygen -o "${SOPS_AGE_KEY_FILE}" 2>/dev/null
  mkdir -p "${FAKE_REPO}/app/config/templates"
  echo "password: hunter2" > "${FAKE_REPO}/app/values-private.yaml"
  cd "${FAKE_REPO}" || exit 1
}

# --- usage and preconditions ---

@test "without a mode it prints the usage and fails" {
  run "${SCRIPT}"
  assert_failure 1
  assert_output --partial "Usage:"
}

@test "an unknown option is refused" {
  run "${SCRIPT}" --bogus
  assert_failure 1
  assert_output --partial 'ERROR: unknown parameter "--bogus"'
}

@test "a missing key file is refused" {
  SOPS_AGE_KEY_FILE="${BATS_TEST_TMPDIR}/nothere.key" run "${SCRIPT}" --decrypt-all
  assert_failure 1
  assert_output --partial "ERROR: SOPS_AGE_KEY_FILE must point to your age key file"
}

# --- single files ---

@test "--encrypt and --decrypt make a round trip, and the encrypted copy hides the content" {
  run "${SCRIPT}" --encrypt app/values-private.yaml
  assert_success
  assert [ -f app/values-private.yaml_encrypted ]
  run grep -c hunter2 app/values-private.yaml_encrypted
  assert_output "0"

  rm app/values-private.yaml
  run "${SCRIPT}" --decrypt app/values-private.yaml_encrypted
  assert_success
  run cat app/values-private.yaml
  assert_output "password: hunter2"
}

@test "--encrypt refuses a missing file and an already encrypted one" {
  run "${SCRIPT}" --encrypt app/nothere-private.yaml
  assert_failure 1
  assert_output --partial "ERROR: --encrypt needs an existing file"

  "${SCRIPT}" --encrypt app/values-private.yaml
  run "${SCRIPT}" --encrypt app/values-private.yaml_encrypted
  assert_failure 1
  assert_output --partial "is already an encrypted file"
}

@test "--decrypt refuses a name without the _encrypted suffix, and a missing file" {
  run "${SCRIPT}" --decrypt app/values-private.yaml
  assert_failure 1
  assert_output --partial "must end with '_encrypted'"

  run "${SCRIPT}" --decrypt app/nothere-private.yaml_encrypted
  assert_failure 1
  assert_output --partial "does not exist"
}

@test "a file encrypted for another key fails to decrypt, with an error" {
  "${SCRIPT}" --encrypt app/values-private.yaml
  rm app/values-private.yaml
  age-keygen -o "${BATS_TEST_TMPDIR}/other.key" 2>/dev/null
  SOPS_AGE_KEY_FILE="${BATS_TEST_TMPDIR}/other.key" run "${SCRIPT}" --decrypt app/values-private.yaml_encrypted
  assert_failure 1
  assert_output --partial "ERROR: Could not decrypt"
}

# --- whole repository ---

@test "--encrypt-all encrypts only non-empty private files outside .git, and never templates" {
  echo "{{ secret }}" > app/config/templates/values-private.yaml.j2
  : > app/empty-private.yaml
  mkdir -p .git/sub && echo "x" > .git/sub/git-private.yaml
  run "${SCRIPT}" --encrypt-all
  assert_success
  assert [ -f app/values-private.yaml_encrypted ]
  assert [ ! -e app/config/templates/values-private.yaml.j2_encrypted ]
  assert [ ! -e app/empty-private.yaml_encrypted ]
  assert [ ! -e .git/sub/git-private.yaml_encrypted ]
}

@test "--encrypt-all leaves unchanged files alone and re-encrypts changed ones" {
  "${SCRIPT}" --encrypt-all
  cp app/values-private.yaml_encrypted "${BATS_TEST_TMPDIR}/before"
  run "${SCRIPT}" --encrypt-all
  assert_success
  assert_output --partial "No differences found. Skipping re-encryption"
  run cmp -s "${BATS_TEST_TMPDIR}/before" app/values-private.yaml_encrypted
  assert_success

  echo "password: changed" > app/values-private.yaml
  run "${SCRIPT}" --encrypt-all
  assert_success
  assert_output --partial "Differences found. Re-encrypting"
  rm app/values-private.yaml
  "${SCRIPT}" --decrypt app/values-private.yaml_encrypted
  run cat app/values-private.yaml
  assert_output "password: changed"
}

@test "--decrypt-all creates missing plaintext files" {
  "${SCRIPT}" --encrypt-all
  rm app/values-private.yaml
  run "${SCRIPT}" --decrypt-all
  assert_success
  run cat app/values-private.yaml
  assert_output "password: hunter2"
}

@test "--decrypt-all passes when every plaintext matches its encrypted copy" {
  "${SCRIPT}" --encrypt-all
  run "${SCRIPT}" --decrypt-all
  assert_success
  assert_output --partial "No differences found between decrypted content and existing file."
}

@test "--decrypt-all fails on a stale plaintext and lists it, without touching it" {
  "${SCRIPT}" --encrypt-all
  echo "password: edited-but-not-encrypted" > app/values-private.yaml
  run "${SCRIPT}" --decrypt-all
  assert_failure 1
  assert_output --partial "ERROR: 1 decrypted file(s) differ from their encrypted copy:"
  assert_output --partial "  ${FAKE_REPO}/app/values-private.yaml"
  run cat app/values-private.yaml
  assert_output "password: edited-but-not-encrypted"
}

@test "--redecrypt-all overwrites the plaintext with the encrypted content" {
  "${SCRIPT}" --encrypt-all
  echo "password: local-edit" > app/values-private.yaml
  run "${SCRIPT}" --redecrypt-all
  assert_success
  run cat app/values-private.yaml
  assert_output "password: hunter2"
}

@test "--reencrypt-all re-encrypts changed plaintext, and warns about missing plaintext" {
  "${SCRIPT}" --encrypt-all
  echo "other: value" > app/other-private.yaml
  "${SCRIPT}" --encrypt app/other-private.yaml
  rm app/other-private.yaml
  echo "password: rotated" > app/values-private.yaml
  run "${SCRIPT}" --reencrypt-all
  assert_success
  assert_output --partial "Differences found. Re-encrypting"
  assert_output --partial "WARNING: Unencrypted file ${FAKE_REPO}/app/other-private.yaml not found"
  rm app/values-private.yaml
  "${SCRIPT}" --decrypt app/values-private.yaml_encrypted
  run cat app/values-private.yaml
  assert_output "password: rotated"
}

# --- the record of passed pairs ---

PASSED_FILE=security/secret-mgmt/age-sops/.decrypt-all-passed

@test "--decrypt-all skips pairs unchanged since they passed, and records only checksums" {
  "${SCRIPT}" --encrypt-all
  "${SCRIPT}" --decrypt-all
  run "${SCRIPT}" --decrypt-all
  assert_success
  assert_output --partial "Skipped 1 pair(s) unchanged since they last passed."
  refute_output --partial "No differences found"
  run grep -c hunter2 "${PASSED_FILE}"
  assert_output "0"
}

@test "--decrypt-all checks only the changed pair again, and a stale plaintext keeps failing" {
  echo "other: value" > app/other-private.yaml
  "${SCRIPT}" --encrypt-all
  "${SCRIPT}" --decrypt-all
  echo "password: edited-but-not-encrypted" > app/values-private.yaml
  run "${SCRIPT}" --decrypt-all
  assert_failure 1
  assert_output --partial "Skipped 1 pair(s) unchanged since they last passed."
  assert_output --partial "  ${FAKE_REPO}/app/values-private.yaml"
  run "${SCRIPT}" --decrypt-all
  assert_failure 1
  assert_output --partial "  ${FAKE_REPO}/app/values-private.yaml"
}

@test "--decrypt-all checks a pair again when only its encrypted copy changed" {
  "${SCRIPT}" --encrypt-all
  "${SCRIPT}" --decrypt-all
  echo "password: from-a-pull" > "${BATS_TEST_TMPDIR}/pulled-private.yaml"
  "${SCRIPT}" --encrypt "${BATS_TEST_TMPDIR}/pulled-private.yaml"
  cp "${BATS_TEST_TMPDIR}/pulled-private.yaml_encrypted" app/values-private.yaml_encrypted
  run "${SCRIPT}" --decrypt-all
  assert_failure 1
  refute_output --partial "Skipped"
  assert_output --partial "  ${FAKE_REPO}/app/values-private.yaml"
}

@test "--decrypt-all checks everything again without its record" {
  "${SCRIPT}" --encrypt-all
  "${SCRIPT}" --decrypt-all
  rm "${PASSED_FILE}"
  run "${SCRIPT}" --decrypt-all
  assert_success
  refute_output --partial "Skipped"
  assert_output --partial "No differences found between decrypted content and existing file."
}
