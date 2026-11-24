#!/usr/bin/env bats
# The Renovate helpers: the annotation of local charts with their image, and the local full dry run
# covers: automation/gitops/renovate/add-renovate-comment.sh automation/gitops/renovate/dry-run.sh

load helpers

RENOVATE_DIR=automation/gitops/renovate

setup() {
  setup_fake_repo
}

# chart <App folder> <repository>...: a local chart with an appVersion, and the App's values naming the repositories
function chart() {
  local dir="${FAKE_REPO}/$1" repository
  shift
  mkdir -p "${dir}/chart"
  printf 'apiVersion: v2\nname: app\nappVersion: "1.0.0"\n' > "${dir}/chart/Chart.yaml"
  : > "${dir}/app-values.yaml"
  for repository in "$@"; do
    printf 'image:\n  repository: %s\n' "${repository}" >> "${dir}/app-values.yaml"
  done
}

@test "add-renovate-comment.sh annotates a chart whose values name exactly one image, and no other" {
  copy_into_repo "${RENOVATE_DIR}/add-renovate-comment.sh"
  chart apps/one ghcr.io/example/one
  chart apps/two ghcr.io/example/two ghcr.io/example/sidecar
  chart apps/none
  chart apps/done ghcr.io/example/done
  sed -i '/^appVersion:/i # renovate: image=ghcr.io/example/done' "${FAKE_REPO}/apps/done/chart/Chart.yaml"
  cd "${FAKE_REPO}" || exit 1
  run "${RENOVATE_DIR}/add-renovate-comment.sh"
  assert_success
  run grep -B1 '^appVersion:' apps/one/chart/Chart.yaml
  assert_output '# renovate: image=ghcr.io/example/one
appVersion: "1.0.0"'
  run grep -c 'renovate:' apps/two/chart/Chart.yaml apps/none/chart/Chart.yaml apps/done/chart/Chart.yaml
  assert_output "apps/two/chart/Chart.yaml:0
apps/none/chart/Chart.yaml:0
apps/done/chart/Chart.yaml:1"
}

@test "dry-run.sh needs RENOVATE_TOKEN" {
  copy_into_repo "${RENOVATE_DIR}/dry-run.sh"
  make_stub docker
  cd "${FAKE_REPO}" || exit 1
  RENOVATE_TOKEN='' run "${RENOVATE_DIR}/dry-run.sh"
  assert_failure 1
  assert_output "RENOVATE_TOKEN is not set"
  assert_stub_not_called docker
}

@test "dry-run.sh runs the deployed chart's Renovate image against the repository in full dry-run mode" {
  copy_into_repo "${RENOVATE_DIR}/dry-run.sh" "${RENOVATE_DIR}/renovate-oss/deploy-k8s.sh"
  make_stub helm 0 "image: {registry: ghcr.io, repository: renovatebot/renovate, tag: 43.1.0}"
  make_stub docker
  cd "${FAKE_REPO}" || exit 1
  RENOVATE_TOKEN=token run "${RENOVATE_DIR}/dry-run.sh"
  assert_success
  run grep -c "^docker run .* ghcr.io/renovatebot/renovate:43.1.0 renovate --platform=local --dry-run=full --print-config$" "${STUB_LOG}"
  assert_output "1"
}

@test "dry-run.sh stops when the chart's image can't be read" {
  copy_into_repo "${RENOVATE_DIR}/dry-run.sh" "${RENOVATE_DIR}/renovate-oss/deploy-k8s.sh"
  make_stub helm 1
  make_stub docker
  cd "${FAKE_REPO}" || exit 1
  RENOVATE_TOKEN=token run "${RENOVATE_DIR}/dry-run.sh"
  assert_failure 1
  assert_output --partial "ERROR: Could not read the Renovate image"
  assert_stub_not_called docker
}
