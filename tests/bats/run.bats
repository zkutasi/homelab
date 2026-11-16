#!/usr/bin/env bats
# tests/run.sh --changed: picks the test files that cover the changed files (their "# covers:" headers)
# covers: tests/run.sh

load helpers

setup() {
  setup_fake_repo
  copy_into_repo tests/run.sh tests/bats/helpers.bash tests/bats/stubs/git
  RUNNER="${FAKE_REPO}/tests/run.sh"
  # Fake test files with their headers, and the files they cover
  printf '#!/usr/bin/env bats\n# covers: tool.sh other.sh\n' > "${FAKE_REPO}/tests/bats/tool.bats"
  printf '#!/usr/bin/env bats\n# covers: */deploy-k8s.sh */undeploy-k8s.sh\n' > "${FAKE_REPO}/tests/bats/wrappers.bats"
  touch "${FAKE_REPO}/tool.sh" "${FAKE_REPO}/other.sh"
  make_stub docker
  cd "${FAKE_REPO}" || exit 1
}

@test "a covered script selects the test files that cover it" {
  run "${RUNNER}" --list --changed tool.sh README.md
  assert_success
  assert_output "tests/bats/tool.bats"
}

@test "changed wrappers select wrappers.bats, which then checks only those" {
  # A wrapper one level down: an unquoted */deploy-k8s.sh pattern would expand to it as a file glob
  mkdir -p "${FAKE_REPO}/top" && touch "${FAKE_REPO}/top/deploy-k8s.sh"
  run "${RUNNER}" --list --changed apps/web/deploy-k8s.sh apps/web/undeploy-k8s.sh tool.sh
  assert_success
  assert_output "tests/bats/tool.bats
tests/bats/wrappers.bats
INFO: wrappers.bats checks only: apps/web/deploy-k8s.sh apps/web/undeploy-k8s.sh"
}

@test "a changed test file runs itself, completely" {
  run "${RUNNER}" --list --changed tests/bats/wrappers.bats apps/web/deploy-k8s.sh
  assert_success
  assert_output "tests/bats/wrappers.bats"
}

@test "a harness change runs every test file, completely" {
  local harness
  for harness in tests/run.sh tests/bats/helpers.bash tests/bats/stubs/git; do
    run "${RUNNER}" --list --changed "${harness}" apps/web/deploy-k8s.sh
    assert_success
    assert_output "tests/bats/tool.bats
tests/bats/wrappers.bats"
  done
}

@test "other files under tests/ select nothing, even when a pattern would match them" {
  run "${RUNNER}" --list --changed tests/renovate/fixtures/apps/web/deploy-k8s.sh
  assert_success
  assert_output "INFO: No test covers the changed files"
}

@test "when nothing is covered, no container is started" {
  run "${RUNNER}" --changed README.md docs/notes.md
  assert_success
  assert_output "INFO: No test covers the changed files"
  assert_stub_not_called docker
}

@test "selected test files run in the container, with the changed wrappers passed in" {
  run "${RUNNER}" --changed apps/web/deploy-k8s.sh
  assert_success
  run grep -c "^docker run .* -e WRAPPERS_ONLY=apps/web/deploy-k8s.sh .* /code/tests/bats/wrappers.bats$" "${STUB_LOG}"
  assert_output "1"
}

@test "without --changed, --list shows every test file" {
  run "${RUNNER}" --list
  assert_success
  assert_output "tests/bats/tool.bats
tests/bats/wrappers.bats"
}

@test "a covered path that no longer exists is warned about" {
  rm "${FAKE_REPO}/other.sh"
  run "${RUNNER}" --list --changed tool.sh
  assert_success
  assert_line "WARNING: tests/bats/tool.bats covers other.sh, which doesn't exist"
  assert_line "tests/bats/tool.bats"
}

@test "--changed can't be combined with --lint or --renovate" {
  run "${RUNNER}" --changed --lint tool.sh
  assert_failure 1
  assert_output --partial "can't be combined"
}

@test "--render hands over to the render tests, with the changed files when given" {
  write_stub "${FAKE_REPO}/tests/render/render.sh"
  run "${RUNNER}" --render
  assert_success
  run "${RUNNER}" --render --changed apps/web/docker-compose.yaml.j2
  assert_success
  assert_stub_calls "render.sh" "render.sh --changed apps/web/docker-compose.yaml.j2"
  run "${RUNNER}" --render some.bats
  assert_failure 1
  assert_output --partial "take no test files"
}
