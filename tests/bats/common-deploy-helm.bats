#!/usr/bin/env bats
# common-deploy-helm.sh: finds the values files, picks the chart version, installs (or templates) the chart,
# then applies the CNPG Prometheus rules and the extra manifests
# covers: common-deploy-helm.sh

load helpers

setup() {
  setup_fake_repo
  copy_into_repo common-deploy-helm.sh
  HELPER="${FAKE_REPO}/common-deploy-helm.sh"
  APP_DIR="${FAKE_REPO}/apps/web"
  mkdir -p "${APP_DIR}"
  cd "${APP_DIR}" || exit 1
  # The helm stub answers from these variables:
  #   HELM_REPOS (repo list output), HELM_DEPLOYED (deployed version, empty: not installed),
  #   HELM_LATEST (latest chart version), HELM_VALUES (computed release values), HELM_FAIL (sub-command that fails)
  export HELM_REPOS="" HELM_DEPLOYED="" HELM_LATEST="9.9.9" HELM_VALUES="{}" HELM_FAIL=""
  make_stub_script helm '
args=" $* "
if [ -n "${HELM_FAIL}" ] && [[ "${args}" == *" ${HELM_FAIL} "* ]]; then exit 1; fi
case "${args}" in
  *" repo list "*) echo "${HELM_REPOS}" ;;
  *" get metadata "*) [ -n "${HELM_DEPLOYED}" ] || exit 1; printf "NAME: x\nVERSION: %s\n" "${HELM_DEPLOYED}" ;;
  *" show chart "*) printf "name: chart\nversion: %s\n" "${HELM_LATEST}" ;;
  *" get values "*) echo "${HELM_VALUES}" ;;
  *" template "*) echo "kind: PrometheusRule" ;;
esac
exit 0'
  # Only "kubectl apply -f -" reads stdin; inside the helper's loops stdin is the file list
  make_stub_script kubectl '
[[ " $* " == *" -f - "* ]] && cat > /dev/null
[[ " $* " == *broken* ]] && exit 1
exit 0'
}

# deploy [args...]: runs the helper with the common required options of an OCI chart, plus the arguments
function deploy() {
  run "${HELPER}" --chart-name oci://registry.example.com/charts/web --namespace web --release-name web "$@"
}

# --- usage and option errors ---

@test "--help prints the usage and succeeds" {
  run "${HELPER}" --help
  assert_success
  assert_output --partial "Usage:"
}

@test "an unknown option is refused" {
  deploy --bogus
  assert_failure 1
  assert_output --partial 'ERROR: unknown parameter "--bogus"'
}

@test "options that need a value refuse a missing value" {
  local option
  for option in --app --chart-name --extra-values --namespace --post-renderer --release-name --repo-url --type --version; do
    run "${HELPER}" "${option}"
    assert_failure 1
    assert_output --partial "ERROR: ${option} needs a value"
  done
}

@test "an invalid deployment type is refused" {
  deploy --type kustomize
  assert_failure 1
  assert_output --partial "ERROR: Invalid deployment type"
  assert_stub_not_called helm
}

@test "each deployment type needs a chart name, a namespace and a release name" {
  local type
  for type in helm truecharts local; do
    run "${HELPER}" --type "${type}" --namespace web --release-name web
    assert_failure 1
    assert_output --partial "ERROR: Chart name must be specified"
    run "${HELPER}" --type "${type}" --chart-name oci://x/y --release-name web
    assert_failure 1
    assert_output --partial "ERROR: Namespace must be specified"
    run "${HELPER}" --type "${type}" --chart-name oci://x/y --namespace web
    assert_failure 1
    assert_output --partial "ERROR: Release name must be specified"
  done
  assert_stub_not_called helm
}

@test "a non-OCI Helm chart needs a repo URL" {
  run "${HELPER}" --chart-name example/web --namespace web --release-name web
  assert_failure 1
  assert_output --partial "ERROR: Repo URL must be specified"
}

@test "a missing extra values file stops before helm runs" {
  deploy --extra-values nothere.yaml
  assert_failure 1
  assert_output --partial "ERROR: Extra values file nothere.yaml not found"
  assert_stub_not_called helm
}

# --- values files ---

@test "the App's values files are used in a fixed order, missing ones are skipped" {
  touch app-values.yaml app-values-dimensioning.yaml extra.yaml
  deploy --version 1.0.0 --extra-values extra.yaml
  assert_success
  assert_output --partial "INFO: No values file app-values-private.yaml found, skipping"
  assert_stub_called "helm upgrade --install web oci://registry.example.com/charts/web --version 1.0.0 --namespace web --create-namespace --values app-values.yaml --values app-values-dimensioning.yaml --values extra.yaml"
}

@test "--app changes the values file prefix" {
  touch app-values.yaml db-values.yaml db-values-private.yaml
  deploy --version 1.0.0 --app db
  assert_success
  assert_stub_called "helm upgrade --install web oci://registry.example.com/charts/web --version 1.0.0 --namespace web --create-namespace --values db-values.yaml --values db-values-private.yaml"
}

# --- chart repository ---

@test "a non-OCI repo is added when missing, then updated" {
  run "${HELPER}" --chart-name example/web --repo-url https://charts.example.com --namespace web --release-name web --version 1.0.0
  assert_success
  assert_stub_called "helm repo add example https://charts.example.com"
  assert_stub_called "helm repo update example"
}

@test "an already added repo is only updated" {
  export HELM_REPOS="example	https://charts.example.com"
  run "${HELPER}" --chart-name example/web --repo-url https://charts.example.com --namespace web --release-name web --version 1.0.0
  assert_success
  run grep -c "^helm repo add" "${STUB_LOG}"
  assert_output "0"
  assert_stub_called "helm repo update example"
}

@test "an OCI chart needs no repo" {
  deploy --version 1.0.0
  assert_success
  run grep -c "^helm repo" "${STUB_LOG}"
  assert_output "0"
}

# --- chart version ---

@test "--version is used as given, without asking the cluster or the registry" {
  export HELM_DEPLOYED="1.0.0"
  deploy --version 2.0.0
  assert_success
  run grep -c -e "get metadata" -e "show chart" "${STUB_LOG}"
  assert_output "0"
  assert_stub_called "helm upgrade --install web oci://registry.example.com/charts/web --version 2.0.0 --namespace web --create-namespace"
}

@test "without --version the deployed version is kept" {
  export HELM_DEPLOYED="1.5.0"
  deploy
  assert_success
  assert_stub_called "helm -n web get metadata web"
  assert_stub_called "helm upgrade --install web oci://registry.example.com/charts/web --version 1.5.0 --namespace web --create-namespace"
}

@test "without --version and without a deployed release the latest chart version is used" {
  deploy
  assert_success
  assert_stub_called "helm show chart oci://registry.example.com/charts/web"
  assert_stub_called "helm upgrade --install web oci://registry.example.com/charts/web --version 9.9.9 --namespace web --create-namespace"
}

@test "--latest ignores the deployed version" {
  export HELM_DEPLOYED="1.5.0"
  deploy --latest
  assert_success
  run grep -c "get metadata" "${STUB_LOG}"
  assert_output "0"
  assert_stub_called "helm upgrade --install web oci://registry.example.com/charts/web --version 9.9.9 --namespace web --create-namespace"
}

@test "no version found at all is an error" {
  export HELM_LATEST=""
  deploy
  assert_failure 1
  assert_output --partial "ERROR: No version specified"
}

@test "a local chart gets its dependencies updated and the version 'local'" {
  run "${HELPER}" --type local --chart-name ./chart --namespace web --release-name web
  assert_success
  assert_stub_called "helm dependency update ./chart"
  assert_stub_called "helm upgrade --install web ./chart --version local --namespace web --create-namespace"
  run grep -c "get metadata" "${STUB_LOG}"
  assert_output "0"
}

# --- the helm command ---

@test "--debug and --post-renderer are passed on" {
  deploy --version 1.0.0 --debug --post-renderer ./kustomize.sh
  assert_success
  assert_stub_called "helm upgrade --install web oci://registry.example.com/charts/web --version 1.0.0 --namespace web --create-namespace --debug --post-renderer ./kustomize.sh"
}

@test "--template renders instead of installing, and applies nothing" {
  mkdir extra-manifests && touch extra-manifests/a.yaml
  deploy --version 1.0.0 --template
  assert_success
  assert_stub_called "helm template web oci://registry.example.com/charts/web --version 1.0.0 --namespace web --create-namespace"
  assert_stub_not_called kubectl
}

@test "--template without --version doesn't ask the cluster" {
  export HELM_DEPLOYED="1.5.0"
  deploy --template
  assert_success
  run grep -c "get metadata" "${STUB_LOG}"
  assert_output "0"
}

@test "a failed helm install stops before anything else is applied" {
  export HELM_FAIL="upgrade"
  mkdir extra-manifests && touch extra-manifests/a.yaml
  deploy --version 1.0.0
  assert_failure 1
  assert_output --partial "ERROR: helm failed, not applying anything else"
  assert_stub_not_called kubectl
}

# --- after the install ---

@test "the extra manifests are applied in sorted order, YAML files only, in the namespace" {
  mkdir -p extra-manifests/sub
  touch extra-manifests/b.yaml extra-manifests/a.yaml extra-manifests/sub/c.yaml extra-manifests/notes.txt extra-manifests/d.yml
  deploy --version 1.0.0
  assert_success
  assert_stub_calls \
    "helm upgrade --install web oci://registry.example.com/charts/web --version 1.0.0 --namespace web --create-namespace" \
    "kubectl apply -f ./extra-manifests/a.yaml -n web" \
    "kubectl apply -f ./extra-manifests/b.yaml -n web" \
    "kubectl apply -f ./extra-manifests/sub/c.yaml -n web"
}

@test "--no-extra-manifests skips them" {
  mkdir extra-manifests && touch extra-manifests/a.yaml
  deploy --version 1.0.0 --no-extra-manifests
  assert_success
  assert_stub_not_called kubectl
}

@test "a failed extra manifest makes the deploy fail, after trying all of them" {
  mkdir extra-manifests && touch extra-manifests/a-broken.yaml extra-manifests/b.yaml
  deploy --version 1.0.0
  assert_failure
  assert_stub_called "kubectl apply -f ./extra-manifests/b.yaml -n web"
}

@test "TrueCharts and local charts get the CNPG Prometheus rules of each enabled cluster" {
  export HELM_VALUES='cnpg:
  main:
    enabled: true
  spare:
    enabled: false
  second:
    enabled: true'
  run "${HELPER}" --type truecharts --chart-name oci://tccr.io/truecharts/web --namespace web --release-name web --version 1.0.0
  assert_success
  assert_stub_called "helm -n web get values -a web"
  local cnpg_version cluster
  cnpg_version=$(sed -n 's/^CNPG_CLUSTER_CHART_VERSION=//p' "${HELPER}")
  for cluster in main second; do
    assert_stub_called "helm template --release-name web-cnpg --namespace web --set nameOverride=${cluster} --set cluster.monitoring.enabled=true --set cluster.monitoring.prometheusRule.excludeRules\\[0\\]=CNPGClusterHAWarning --set cluster.monitoring.prometheusRule.excludeRules\\[1\\]=CNPGClusterHACritical --show-only templates/prometheus-rule.yaml --repo https://cloudnative-pg.github.io/charts --version ${cnpg_version} cluster"
  done
  run grep -c "nameOverride=spare" "${STUB_LOG}"
  assert_output "0"
  run grep -c "^kubectl apply -f -$" "${STUB_LOG}"
  assert_output "2"
}

@test "public Helm charts get no CNPG lookup" {
  deploy --version 1.0.0
  assert_success
  run grep -c "get values" "${STUB_LOG}"
  assert_output "0"
}

@test "a failed CNPG rule, on either side of the pipe, makes the deploy fail" {
  export HELM_VALUES='cnpg:
  main:
    enabled: true'
  export HELM_FAIL="--show-only"
  run "${HELPER}" --type truecharts --chart-name oci://tccr.io/truecharts/web --namespace web --release-name web --version 1.0.0
  assert_failure 1
}
