#!/usr/bin/env bats
# Tests of the test harness itself: the git stub and the stub helpers
# covers: tests/bats/helpers.bash tests/bats/stubs/git

load helpers

setup() {
  setup_fake_repo
}

@test "git stub prints the fake repository root" {
  cd "${FAKE_REPO}" || exit 1
  run git rev-parse --show-toplevel
  assert_success
  assert_output "${FAKE_REPO}"
}

@test "git stub walks up from a sub-folder, like git" {
  mkdir -p "${FAKE_REPO}/some/sub/folder"
  cd "${FAKE_REPO}/some/sub/folder" || exit 1
  run git rev-parse --show-toplevel
  assert_success
  assert_output "${FAKE_REPO}"
}

@test "git stub fails outside a repository" {
  cd "${BATS_TEST_TMPDIR}" || exit 1
  run git rev-parse --show-toplevel
  assert_failure 128
  assert_output --partial "not a git repository"
}

@test "git stub refuses any other git command" {
  cd "${FAKE_REPO}" || exit 1
  run git status
  assert_failure 1
  assert_output --partial "only supports 'git rev-parse --show-toplevel'"
}

@test "make_stub logs its arguments, prints its output and exits with its code" {
  make_stub some-tool 3 "hello world"
  run some-tool --flag "two words"
  assert_failure 3
  assert_output "hello world"
  assert_stub_called "some-tool --flag two\\ words"
  assert_stub_not_called other-tool
}

@test "make_stub logs the requested environment variables, set or not" {
  STUB_ENV_VARS="SET_ONE UNSET_ONE" make_stub env-tool
  SET_ONE="a value" env-tool
  assert_stub_called "env-tool"
  assert_stub_called "SET_ONE=a value"
  assert_stub_called "UNSET_ONE unset"
}

@test "copy_into_repo copies a file of the real repository with its mode" {
  copy_into_repo common-ansible-run-playbook.sh
  assert [ -x "${FAKE_REPO}/common-ansible-run-playbook.sh" ]
}
