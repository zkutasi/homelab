#!/usr/bin/env bats
# common-undeploy-helm.sh: deletes the extra manifests, uninstalls the release if it exists,
# and deletes the namespace unless told not to

load helpers

setup() {
  setup_fake_repo
  copy_into_repo common-undeploy-helm.sh
  HELPER="${FAKE_REPO}/common-undeploy-helm.sh"
  mkdir -p "${FAKE_REPO}/apps/web"
  cd "${FAKE_REPO}/apps/web" || exit 1
  # HELM_RELEASES: the "helm list --short" output; HELM_LIST_FAIL=1 makes the listing fail
  export HELM_RELEASES="web" HELM_LIST_FAIL=0
  make_stub_script helm '
if [[ " $* " == *" list "* ]]; then [ "${HELM_LIST_FAIL}" -eq 1 ] && exit 1; echo "${HELM_RELEASES}"; fi
[[ " $* " == *" uninstall "* ]] && [ "${HELM_UNINSTALL_FAIL:-0}" -eq 1 ] && exit 1
exit 0'
  # KUBECTL_FAIL: an argument that makes kubectl fail
  export KUBECTL_FAIL="__none__"
  make_stub_script kubectl '
[[ " $* " == *"${KUBECTL_FAIL}"* ]] && exit 1
exit 0'
}

@test "--help prints the usage and succeeds" {
  run "${HELPER}" --help
  assert_success
  assert_output --partial "Usage:"
}

@test "an unknown option is refused" {
  run "${HELPER}" --namespace web --release-name web --bogus
  assert_failure 1
  assert_output --partial 'ERROR: unknown parameter "--bogus"'
}

@test "the namespace and the release name are required" {
  run "${HELPER}" --release-name web
  assert_failure 1
  assert_output --partial "ERROR: No namespace specified"
  run "${HELPER}" --namespace web
  assert_failure 1
  assert_output --partial "ERROR: No release name specified"
  assert_stub_not_called helm
  assert_stub_not_called kubectl
}

@test "--delete-namespace only takes 0 or 1" {
  run "${HELPER}" --namespace web --release-name web --delete-namespace yes
  assert_failure 1
  assert_output --partial 'ERROR: --delete-namespace must be 0 or 1, got "yes"'
  assert_stub_not_called kubectl
}

@test "by default it deletes the manifests, uninstalls the release and deletes the namespace" {
  mkdir -p extra-manifests && touch extra-manifests/b.yaml extra-manifests/a.yaml extra-manifests/notes.txt
  run "${HELPER}" --namespace web --release-name web
  assert_success
  assert_stub_calls \
    "kubectl delete -f ./extra-manifests/a.yaml -n web --ignore-not-found" \
    "kubectl delete -f ./extra-manifests/b.yaml -n web --ignore-not-found" \
    "helm -n web list --short" \
    "helm uninstall web --namespace web --wait" \
    "kubectl delete namespace web --ignore-not-found"
}

@test "--delete-namespace 0 keeps the namespace, --debug is passed on" {
  run "${HELPER}" --namespace web --release-name web --delete-namespace 0 --debug
  assert_success
  assert_stub_called "helm uninstall web --namespace web --wait --debug"
  assert_stub_not_called "kubectl delete namespace"
}

@test "a release that isn't installed is skipped, the namespace still goes" {
  export HELM_RELEASES="other-web
web-db"
  run "${HELPER}" --namespace web --release-name web
  assert_success
  assert_output --partial "Helm release web not found in namespace web, skipping uninstall"
  assert_stub_not_called "helm uninstall"
  assert_stub_called "kubectl delete namespace web --ignore-not-found"
}

@test "a failed release listing stops before uninstalling or deleting the namespace" {
  export HELM_LIST_FAIL=1
  run "${HELPER}" --namespace web --release-name web
  assert_failure 1
  assert_output --partial "ERROR: Could not list the Helm releases in namespace web"
  assert_stub_not_called "helm uninstall"
  assert_stub_not_called "kubectl delete namespace"
}

@test "a failed manifest delete, uninstall or namespace delete makes it fail, after trying everything" {
  mkdir -p extra-manifests && touch extra-manifests/a-broken.yaml extra-manifests/b.yaml
  export KUBECTL_FAIL="broken"
  run "${HELPER}" --namespace web --release-name web
  assert_failure 1
  assert_stub_called "kubectl delete -f ./extra-manifests/b.yaml -n web --ignore-not-found"
  assert_stub_called "kubectl delete namespace web --ignore-not-found"

  : > "${STUB_LOG}"
  export KUBECTL_FAIL="__none__" HELM_UNINSTALL_FAIL=1
  run "${HELPER}" --namespace web --release-name web
  assert_failure 1
  assert_stub_called "kubectl delete namespace web --ignore-not-found"

  export HELM_UNINSTALL_FAIL=0 KUBECTL_FAIL="delete namespace"
  run "${HELPER}" --namespace web --release-name web
  assert_failure 1
}
