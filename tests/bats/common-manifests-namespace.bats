#!/usr/bin/env bats
# common-deploy-manifests.sh (applies the extra manifests, optionally into a namespace it creates) and
# common-undeploy-namespace.sh (deletes a namespace)

load helpers

setup() {
  setup_fake_repo
  copy_into_repo common-deploy-manifests.sh common-undeploy-namespace.sh
  mkdir -p "${FAKE_REPO}/apps/web"
  cd "${FAKE_REPO}/apps/web" || exit 1
  # KUBECTL_NS_EXISTS=1: "kubectl get namespace" finds it
  export KUBECTL_NS_EXISTS=0
  make_stub_script kubectl '
if [[ " $* " == *" get namespace "* ]]; then [ "${KUBECTL_NS_EXISTS}" -eq 1 ] || exit 1; fi
[[ " $* " == *broken* ]] && exit 1
exit 0'
}

# --- common-deploy-manifests.sh ---

@test "manifests: --help works and unknown options are refused" {
  run "${FAKE_REPO}/common-deploy-manifests.sh" --help
  assert_success
  assert_output --partial "Usage:"
  run "${FAKE_REPO}/common-deploy-manifests.sh" --bogus
  assert_failure 1
  assert_output --partial 'ERROR: unknown parameter "--bogus"'
}

@test "manifests: with a namespace it creates a missing one, then applies sorted YAML files into it" {
  mkdir -p extra-manifests && touch extra-manifests/b.yaml extra-manifests/a.yaml extra-manifests/c.yml
  run "${FAKE_REPO}/common-deploy-manifests.sh" --namespace web
  assert_success
  assert_stub_calls \
    "kubectl get namespace web" \
    "kubectl create namespace web" \
    "kubectl apply -f ./extra-manifests/a.yaml --namespace web" \
    "kubectl apply -f ./extra-manifests/b.yaml --namespace web"
}

@test "manifests: an existing namespace isn't created again" {
  export KUBECTL_NS_EXISTS=1
  run "${FAKE_REPO}/common-deploy-manifests.sh" --namespace web
  assert_success
  assert_stub_not_called "kubectl create"
}

@test "manifests: without a namespace the manifests keep their own" {
  mkdir -p extra-manifests && touch extra-manifests/a.yaml
  run "${FAKE_REPO}/common-deploy-manifests.sh"
  assert_success
  assert_stub_calls "kubectl apply -f ./extra-manifests/a.yaml"
}

@test "manifests: a failed manifest makes it fail, after trying all of them" {
  mkdir -p extra-manifests && touch extra-manifests/a-broken.yaml extra-manifests/b.yaml
  run "${FAKE_REPO}/common-deploy-manifests.sh" --namespace web
  assert_failure
  assert_stub_called "kubectl apply -f ./extra-manifests/b.yaml --namespace web"
}

# --- common-undeploy-namespace.sh ---

@test "namespace: it needs a namespace" {
  run "${FAKE_REPO}/common-undeploy-namespace.sh"
  assert_failure 1
  assert_output --partial "ERROR: No namespace specified"
  assert_stub_not_called kubectl
}

@test "namespace: it deletes the namespace, missing or not" {
  run "${FAKE_REPO}/common-undeploy-namespace.sh" --namespace web
  assert_success
  assert_stub_calls "kubectl delete namespace web --ignore-not-found"
}
