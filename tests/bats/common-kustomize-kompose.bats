#!/usr/bin/env bats
# common-deploy-kustomize.sh, common-undeploy-kustomize.sh and common-deploy-kompose.sh
# covers: common-deploy-kustomize.sh common-undeploy-kustomize.sh common-deploy-kompose.sh

load helpers

setup() {
  setup_fake_repo
  copy_into_repo common-deploy-kustomize.sh common-undeploy-kustomize.sh common-deploy-kompose.sh
  mkdir -p "${FAKE_REPO}/apps/web"
  cd "${FAKE_REPO}/apps/web" || exit 1
  # KUBECTL_FAIL: an argument that makes kubectl fail; "kubectl get namespace" never finds one
  export KUBECTL_FAIL="__none__"
  make_stub_script kubectl '
[[ " $* " == *" get namespace "* ]] && exit 1
[[ " $* " == *"${KUBECTL_FAIL}"* ]] && exit 1
exit 0'
  # The kompose stub writes two manifests, like a conversion would; KOMPOSE_FAIL=1 makes it fail
  export KOMPOSE_FAIL=0
  make_stub_script kompose '
[ "${KOMPOSE_FAIL}" -eq 1 ] && exit 1
touch ./kompose-manifests/web-service.yaml ./kompose-manifests/web-deployment.yaml
exit 0'
}

@test "all three need a namespace" {
  local helper
  for helper in common-deploy-kustomize.sh common-undeploy-kustomize.sh common-deploy-kompose.sh; do
    run "${FAKE_REPO}/${helper}"
    assert_failure 1
    assert_output --partial "ERROR: No namespace specified"
  done
  assert_stub_not_called kubectl
  assert_stub_not_called kompose
}

@test "kustomize: it creates the namespace, applies the kustomization, then the extra manifests" {
  mkdir -p extra-manifests && touch extra-manifests/b.yaml extra-manifests/a.yaml
  run "${FAKE_REPO}/common-deploy-kustomize.sh" --namespace web
  assert_success
  assert_stub_calls \
    "kubectl get namespace web" \
    "kubectl create namespace web" \
    "kubectl apply --kustomize . --namespace web" \
    "kubectl apply -f ./extra-manifests/a.yaml -n web" \
    "kubectl apply -f ./extra-manifests/b.yaml -n web"
}

@test "kustomize: a failed kustomization stops before the extra manifests" {
  export KUBECTL_FAIL="--kustomize"
  mkdir -p extra-manifests && touch extra-manifests/a.yaml
  run "${FAKE_REPO}/common-deploy-kustomize.sh" --namespace web
  assert_failure 1
  assert_output --partial "ERROR: kubectl apply failed, not applying anything else"
  assert_stub_not_called "kubectl apply -f"
}

@test "kustomize: --template only prints the kustomization, without touching the cluster" {
  mkdir -p extra-manifests && touch extra-manifests/a.yaml
  run "${FAKE_REPO}/common-deploy-kustomize.sh" --namespace web --template
  assert_success
  assert_stub_calls "kubectl kustomize ."
}

@test "kustomize: --template-output writes the render into the file instead of stdout" {
  make_stub_script kubectl 'echo "kind: ConfigMap"'
  run "${FAKE_REPO}/common-deploy-kustomize.sh" --namespace web --template-output "${BATS_TEST_TMPDIR}/render.yaml"
  assert_success
  refute_output --partial "kind: ConfigMap"
  assert_stub_calls "kubectl kustomize ."
  run cat "${BATS_TEST_TMPDIR}/render.yaml"
  assert_output "kind: ConfigMap"
}

@test "kustomize: --template-output needs a value" {
  run "${FAKE_REPO}/common-deploy-kustomize.sh" --namespace web --template-output
  assert_failure 1
  assert_output --partial "ERROR: --template-output needs a value"
  assert_stub_not_called kubectl
}

@test "kustomize: a failed --template render fails" {
  export KUBECTL_FAIL="kustomize"
  run "${FAKE_REPO}/common-deploy-kustomize.sh" --namespace web --template
  assert_failure 1
  assert_stub_calls "kubectl kustomize ."
}

@test "kustomize: undeploy deletes the kustomization, the extra manifests and the namespace" {
  mkdir -p extra-manifests && touch extra-manifests/a.yaml
  run "${FAKE_REPO}/common-undeploy-kustomize.sh" --namespace web
  assert_success
  assert_stub_calls \
    "kubectl delete --kustomize . --namespace web --ignore-not-found" \
    "kubectl delete -f ./extra-manifests/a.yaml -n web --ignore-not-found" \
    "kubectl delete namespace web --ignore-not-found"
}

@test "kompose: it converts the compose file into a fresh folder, then applies its manifests and the extra ones" {
  mkdir -p kompose-manifests extra-manifests && touch kompose-manifests/stale.yaml extra-manifests/a.yaml
  run "${FAKE_REPO}/common-deploy-kompose.sh" --namespace web
  assert_success
  assert [ ! -e kompose-manifests/stale.yaml ]
  assert_stub_calls \
    "kompose convert --file docker-compose.yaml --service-group-mode label --out ./kompose-manifests" \
    "kubectl get namespace web" \
    "kubectl create namespace web" \
    "kubectl apply -f ./kompose-manifests/web-deployment.yaml -n web" \
    "kubectl apply -f ./kompose-manifests/web-service.yaml -n web" \
    "kubectl apply -f ./extra-manifests/a.yaml -n web"
}

@test "kompose: a failed conversion applies nothing" {
  export KOMPOSE_FAIL=1
  run "${FAKE_REPO}/common-deploy-kompose.sh" --namespace web
  assert_failure 1
  assert_output --partial "ERROR: kompose convert failed, not applying anything"
  assert_stub_not_called kubectl
}

@test "kustomize, kompose: a failed extra manifest makes the deploy fail, after trying all of them" {
  mkdir -p extra-manifests && touch extra-manifests/a-broken.yaml extra-manifests/b.yaml
  export KUBECTL_FAIL="broken"
  run "${FAKE_REPO}/common-deploy-kustomize.sh" --namespace web
  assert_failure 1
  assert_stub_called "kubectl apply -f ./extra-manifests/b.yaml -n web"
  run "${FAKE_REPO}/common-deploy-kompose.sh" --namespace web
  assert_failure 1
}

@test "kustomize undeploy: any failed delete makes it fail, after trying everything" {
  mkdir -p extra-manifests && touch extra-manifests/a-broken.yaml
  export KUBECTL_FAIL="broken"
  run "${FAKE_REPO}/common-undeploy-kustomize.sh" --namespace web
  assert_failure 1
  assert_stub_called "kubectl delete namespace web --ignore-not-found"
  export KUBECTL_FAIL="--kustomize"
  run "${FAKE_REPO}/common-undeploy-kustomize.sh" --namespace web
  assert_failure 1
}
