#!/usr/bin/env bats
# common-deploy-cnpg.sh: creates the database secret and the init values once, then deploys a CNPG cluster
# through common-deploy-helm.sh
# covers: common-deploy-cnpg.sh

load helpers

setup() {
  setup_fake_repo
  copy_into_repo common-deploy-cnpg.sh
  HELPER="${FAKE_REPO}/common-deploy-cnpg.sh"
  CNPG_VERSION=$(sed -n 's/^CNPG_CLUSTER_CHART_VERSION=//p' "${HELPER}")
  write_stub "${FAKE_REPO}/common-deploy-helm.sh"
  mkdir -p "${FAKE_REPO}/apps/web"
  cd "${FAKE_REPO}/apps/web" || exit 1
  # KUBECTL_SECRET_EXISTS=1: the database secret is already there
  export KUBECTL_SECRET_EXISTS=0
  make_stub_script kubectl '
if [[ " $* " == *" get secret "* ]]; then [ "${KUBECTL_SECRET_EXISTS}" -eq 1 ] || exit 1; fi
[[ " $* " == *" get namespace "* ]] && exit 1
exit 0'
}

@test "--help works, and unknown options are ignored with a note (wrappers pass their App's options through)" {
  run "${HELPER}" --help
  assert_success
  assert_output --partial "Usage:"
  run "${HELPER}" --namespace web --bogus
  assert_success
  assert_output --partial "INFO: Ignoring --bogus for the database chart"
  run grep -c -- "--bogus" "${STUB_LOG}"
  assert_output "0"
}

@test "the first deploy creates the secret with the given password and the init values" {
  run "${HELPER}" --app web --namespace web --db-database webdb --db-username webuser --db-password s3cret
  assert_success
  assert_stub_called "kubectl create namespace web"
  assert_stub_called "kubectl create secret generic web-db-password-secret --from-literal=username=webuser --from-literal=password=s3cret --type=kubernetes.io/basic-auth --namespace=web"
  run yq -o=json -I=0 '.cluster.initdb' app-postgresql-values-private.yaml
  assert_output '{"database":"webdb","owner":"webuser","secret":{"name":"web-db-password-secret"}}'
  assert_stub_called "common-deploy-helm.sh --chart-name cnpg/cluster --release-name postgresql --namespace web --repo-url https://cloudnative-pg.github.io/charts --version ${CNPG_VERSION} --app app-postgresql --no-extra-manifests"
}

@test "without --db-password a random 12-character password is generated" {
  run "${HELPER}" --namespace web
  assert_success
  run grep -oE -- "--from-literal=password=[a-zA-Z0-9]{12} " "${STUB_LOG}"
  assert_success
}

@test "an existing secret is kept" {
  export KUBECTL_SECRET_EXISTS=1
  run "${HELPER}" --namespace web --db-password ignored
  assert_success
  assert_stub_not_called "kubectl create"
}

@test "--template only renders: no secret, no values file, and --template is passed on" {
  run "${HELPER}" --namespace web --template --debug
  assert_success
  assert_stub_not_called kubectl
  assert [ ! -e app-postgresql-values-private.yaml ]
  assert_stub_called "common-deploy-helm.sh --chart-name cnpg/cluster --release-name postgresql --namespace web --repo-url https://cloudnative-pg.github.io/charts --version ${CNPG_VERSION} --app app-postgresql --no-extra-manifests --template --debug"
}
