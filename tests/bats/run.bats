#!/usr/bin/env bats
# tests/run.sh --bats --changed: picks the test files that cover the changed files (their "# covers:" headers)
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
  run "${RUNNER}" --bats --list --changed tool.sh README.md
  assert_success
  assert_output "tests/bats/tool.bats"
}

@test "changed wrappers select wrappers.bats, which then checks only those" {
  # A wrapper one level down: an unquoted */deploy-k8s.sh pattern would expand to it as a file glob
  mkdir -p "${FAKE_REPO}/top" && touch "${FAKE_REPO}/top/deploy-k8s.sh"
  run "${RUNNER}" --bats --list --changed apps/web/deploy-k8s.sh apps/web/undeploy-k8s.sh tool.sh
  assert_success
  assert_output "tests/bats/tool.bats
tests/bats/wrappers.bats
INFO: wrappers.bats checks only: apps/web/deploy-k8s.sh apps/web/undeploy-k8s.sh"
}

@test "a changed test file runs itself, completely" {
  run "${RUNNER}" --bats --list --changed tests/bats/wrappers.bats apps/web/deploy-k8s.sh
  assert_success
  assert_output "tests/bats/wrappers.bats"
}

@test "a harness change runs every test file, completely" {
  local harness
  for harness in tests/run.sh tests/bats/helpers.bash tests/bats/stubs/git; do
    run "${RUNNER}" --bats --list --changed "${harness}" apps/web/deploy-k8s.sh
    assert_success
    assert_output "tests/bats/tool.bats
tests/bats/wrappers.bats"
  done
}

@test "other files under tests/ select nothing, even when a pattern would match them" {
  run "${RUNNER}" --bats --list --changed tests/renovate/fixtures/apps/web/deploy-k8s.sh
  assert_success
  assert_output "INFO: No test covers the changed files"
}

@test "when nothing is covered, no container is started" {
  run "${RUNNER}" --bats --changed README.md docs/notes.md
  assert_success
  assert_output "INFO: No test covers the changed files"
  assert_stub_not_called docker
}

@test "selected test files run in the container, with the changed wrappers passed in" {
  run "${RUNNER}" --bats --changed apps/web/deploy-k8s.sh
  assert_success
  run grep -c "^docker run .* -e WRAPPERS_ONLY=apps/web/deploy-k8s.sh .* /code/tests/bats/wrappers.bats$" "${STUB_LOG}"
  assert_output "1"
}

@test "without --changed, --list shows every test file" {
  run "${RUNNER}" --bats --list
  assert_success
  assert_output "tests/bats/tool.bats
tests/bats/wrappers.bats"
}

@test "a covered path that no longer exists is warned about" {
  rm "${FAKE_REPO}/other.sh"
  run "${RUNNER}" --bats --list --changed tool.sh
  assert_success
  assert_line "WARNING: tests/bats/tool.bats covers other.sh, which doesn't exist"
  assert_line "tests/bats/tool.bats"
}

@test "with changed files, the Renovate check runs only for its own files, ansible-lint always" {
  run "${RUNNER}" --renovate --changed tool.sh
  assert_success
  assert_output "INFO: Neither renovate.json nor tests/renovate/ changed, nothing to check"
  assert_stub_not_called docker
  run "${RUNNER}" --lint --changed tool.sh
  assert_success
  run grep -c "^docker run .* --entrypoint ansible-lint " "${STUB_LOG}"
  assert_output "1"
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
  assert_output --partial "takes no arguments without --changed"
}

@test "--render-k8s hands over to the Kubernetes render tests, with the changed files when given" {
  write_stub "${FAKE_REPO}/tests/render/render-k8s.sh"
  run "${RUNNER}" --render-k8s
  assert_success
  run "${RUNNER}" --render-k8s --changed apps/web/app-values.yaml
  assert_success
  assert_stub_calls "render-k8s.sh" "render-k8s.sh --changed apps/web/app-values.yaml"
  run "${RUNNER}" --render-k8s some.bats
  assert_failure 1
  assert_output --partial "takes no arguments without --changed"
}

@test "--molecule hands over to the Molecule runner, with --changed, --list and the roles when given" {
  write_stub "${FAKE_REPO}/tests/molecule/molecule.sh"
  run "${RUNNER}" --molecule binary-install
  assert_success
  run "${RUNNER}" --molecule --list --changed automation/ansible/roles/binary-install/tasks/main.yaml
  assert_success
  run "${RUNNER}" --molecule --keep binary-install
  assert_success
  assert_stub_calls "molecule.sh binary-install" \
    "molecule.sh --changed --list automation/ansible/roles/binary-install/tasks/main.yaml" \
    "molecule.sh --keep binary-install"
}

@test "there is no default suite" {
  run "${RUNNER}"
  assert_failure 1
  assert_line --partial "name the suites to run"
  assert_stub_not_called docker
}

@test "several suites run in the order given, all of them even after a failure, and the run fails if one did" {
  write_stub "${FAKE_REPO}/tests/render/render-k8s.sh" 1
  write_stub "${FAKE_REPO}/tests/render/render.sh"
  run "${RUNNER}" --render-k8s --render --render-k8s --changed apps/web/app-values.yaml
  assert_failure 1
  assert_line "ERROR: render-k8s failed"
  assert_line "INFO: render passed"
  assert_stub_calls "render-k8s.sh --changed apps/web/app-values.yaml" "render.sh --changed apps/web/app-values.yaml"
}

@test "--all runs every suite, fastest first" {
  write_stub "${FAKE_REPO}/tests/render/render.sh"
  write_stub "${FAKE_REPO}/tests/render/render-k8s.sh"
  write_stub "${FAKE_REPO}/tests/molecule/molecule.sh"
  run "${RUNNER}" --all --changed README.md
  run grep "^INFO: Running the" <<< "${output}"
  assert_output "INFO: Running the bats suite...
INFO: Running the renovate suite...
INFO: Running the render suite...
INFO: Running the render-k8s suite...
INFO: Running the molecule suite...
INFO: Running the lint suite..."
}

@test "test files or roles need a single suite" {
  run "${RUNNER}" --bats --molecule tool.bats
  assert_failure 1
  assert_line "ERROR: test files or roles need a single suite"
  assert_stub_not_called docker
}

@test "a covered file under tests/ selects its test file, the Renovate fixtures don't" {
  printf '#!/usr/bin/env bats\n# covers: tests/tool/runner.sh\n' > "${FAKE_REPO}/tests/bats/runner.bats"
  mkdir -p "${FAKE_REPO}/tests/tool" && touch "${FAKE_REPO}/tests/tool/runner.sh"
  run "${RUNNER}" --bats --list --changed tests/tool/runner.sh
  assert_success
  assert_output "tests/bats/runner.bats"
}
