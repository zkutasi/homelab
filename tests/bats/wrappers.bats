#!/usr/bin/env bats
# Every App wrapper (deploy-k8s.sh / undeploy-k8s.sh) refuses to run outside its own folder, and calls its
# helper with its NS and RELEASE_NAME, passing its own arguments on unchanged. Each test loops over all
# wrappers and lists every one that breaks the rule.
# covers: */deploy-k8s.sh */undeploy-k8s.sh

load helpers

# Wrappers that do more than calling one helper, each covered by its own test below
NOT_PLAIN=(
  kubernetes/undeploy-k8s.sh                                                          # kubectl only
  monitoring/ebpf/calico-whisker/undeploy-k8s.sh                                      # kubectl only
  kubernetes/infrastructure/storage/postgresql/cloud-native-pg/operator/undeploy-k8s.sh  # checks for clusters first
)

# The fake repository, the stubs and the wrapper list are prepared once for the whole file: copying and
# reading 228 wrappers per test would cost about a second each time. The tests only read the shared
# repository, apart from the two tests at the end, which add files to folders no other test runs in.
setup_file() {
  export FAKE_REPO="${BATS_FILE_TMPDIR}/repo" STUB_DIR="${BATS_FILE_TMPDIR}/stubs" STUB_LOG="${BATS_FILE_TMPDIR}/stub-calls.log"
  mkdir -p "${FAKE_REPO}/.git" "${STUB_DIR}"
  : > "${STUB_LOG}"
  cp "${REPO_ROOT}/tests/bats/stubs/git" "${STUB_DIR}/git"
  export PATH="${STUB_DIR}:${PATH}"
  local helper
  for helper in "${REPO_ROOT}"/common-*.sh; do
    write_stub "${FAKE_REPO}/$(basename "${helper}")"
  done
  make_stub kubectl
  make_stub helm
  # The wrappers of the real repository, as paths relative to its root
  (cd "${REPO_ROOT}" && find . \
      \( -path ./.git -o -path ./_templates -o -path ./tests -o -name kubespray-repo -o -name wazuh-kubernetes \) -prune \
      -o -type f \( -name deploy-k8s.sh -o -name undeploy-k8s.sh \) -print | sed 's|^\./||' | sort) > "${BATS_FILE_TMPDIR}/wrappers.txt"
  # tests/run.sh --bats --changed passes the changed wrappers in WRAPPERS_ONLY: then only those are checked
  if [ -n "${WRAPPERS_ONLY:-}" ]; then
    tr ' ' '\n' <<< "${WRAPPERS_ONLY}" | grep -Fx -f - "${BATS_FILE_TMPDIR}/wrappers.txt" > "${BATS_FILE_TMPDIR}/only.txt" || true
    mv "${BATS_FILE_TMPDIR}/only.txt" "${BATS_FILE_TMPDIR}/wrappers.txt"
  fi
  local -a wrappers
  mapfile -t wrappers < "${BATS_FILE_TMPDIR}/wrappers.txt"
  : > "${BATS_FILE_TMPDIR}/values.tsv"
  [ "${#wrappers[@]}" -eq 0 ] && return
  # All wrappers go into the fake repository in one go, at their own paths
  (cd "${REPO_ROOT}" && tar cf - "${wrappers[@]}") | (cd "${FAKE_REPO}" && tar xf -)
  # Per wrapper, in one pass: its NS, its RELEASE_NAME, and whether it passes --release-name at all
  (cd "${REPO_ROOT}" && awk '
      FNR == 1 { if (NR > 1) print f "\t" ns "\t" rel "\t" passes; f = FILENAME; ns = ""; rel = ""; passes = 0 }
      /^NS=/ && ns == "" { ns = substr($0, 4); gsub(/"/, "", ns) }
      /^RELEASE_NAME=/ && rel == "" { rel = substr($0, 14); gsub(/"/, "", rel) }
      /--release-name/ { passes = 1 }
      END { print f "\t" ns "\t" rel "\t" passes }' "${wrappers[@]}") > "${BATS_FILE_TMPDIR}/values.tsv"
}

setup() {
  : > "${STUB_LOG}"
  mapfile -t WRAPPERS < "${BATS_FILE_TMPDIR}/wrappers.txt"
  declare -gA NS_OF RELEASE_OF PASSES_RELEASE
  local file ns release passes
  while IFS=$'\t' read -r file ns release passes; do
    NS_OF[${file}]=${ns}
    RELEASE_OF[${file}]=${release}
    PASSES_RELEASE[${file}]=${passes}
  done < "${BATS_FILE_TMPDIR}/values.tsv"
}

function is_plain() {
  local other
  for other in "${NOT_PLAIN[@]}"; do
    [ "$1" = "${other}" ] && return 1
  done
  return 0
}

@test "the wrapper list is complete enough to mean something" {
  [ -n "${WRAPPERS_ONLY:-}" ] && skip "only the changed wrappers are checked"
  assert [ "${#WRAPPERS[@]}" -gt 200 ]
}

@test "every wrapper refuses to run from another folder, before calling anything" {
  local wrapper out rc failures=()
  cd "${FAKE_REPO}" || exit 1
  for wrapper in "${WRAPPERS[@]}"; do
    : > "${STUB_LOG}"
    rc=0
    out=$("${FAKE_REPO}/${wrapper}" 2>&1) || rc=$?
    if [ "${rc}" -ne 1 ] || [[ "${out}" != *"ERROR: Run ${wrapper##*/} from its own folder"* ]] || [ -s "${STUB_LOG}" ]; then
      failures+=("${wrapper} (exit ${rc})")
    fi
  done
  assert_equal "$(printf '%s\n' "${failures[@]}")" ""
}

@test "every plain wrapper parses its arguments in the standard while loop, into the EXTRA_PARAMS array" {
  local wrapper failures=()
  for wrapper in "${WRAPPERS[@]}"; do
    is_plain "${wrapper}" || continue
    grep -q '^while \[ \$# -ge 1 \]; do$' "${REPO_ROOT}/${wrapper}" \
      && grep -q '^      EXTRA_PARAMS+=("\$1")$' "${REPO_ROOT}/${wrapper}" \
      || failures+=("${wrapper}")
  done
  assert_equal "$(printf '%s\n' "${failures[@]}")" ""
}

@test "every plain wrapper calls exactly one helper, with its NS and RELEASE_NAME, and its arguments last" {
  local wrapper ns release line logged failures=()
  for wrapper in "${WRAPPERS[@]}"; do
    is_plain "${wrapper}" || continue
    ns=${NS_OF[${wrapper}]}
    release=${RELEASE_OF[${wrapper}]}
    : > "${STUB_LOG}"
    cd "${FAKE_REPO}/${wrapper%/*}" || exit 1
    "./${wrapper##*/}" --template --debug > /dev/null 2>&1
    mapfile -t logged < "${STUB_LOG}"
    line=${logged[0]:-}
    if [ "${#logged[@]}" -ne 1 ] || [[ "${line}" != common-*.sh\ * ]]; then
      failures+=("${wrapper}: ${#logged[@]} calls: ${line}")
    elif [[ " ${line} " != *" --namespace ${ns} "* ]]; then
      failures+=("${wrapper}: no --namespace ${ns}: ${line}")
    elif [ "${PASSES_RELEASE[${wrapper}]}" -eq 1 ] && [[ " ${line} " != *" --release-name ${release} "* ]]; then
      failures+=("${wrapper}: no --release-name ${release}: ${line}")
    elif [[ "${line}" != *" --template --debug" ]]; then
      failures+=("${wrapper}: arguments not passed on last: ${line}")
    fi
  done
  assert_equal "$(printf '%s\n' "${failures[@]}")" ""
}

@test "every plain wrapper passes arguments on unchanged, even with spaces or glob characters" {
  local wrapper line logged failures=()
  for wrapper in "${WRAPPERS[@]}"; do
    is_plain "${wrapper}" || continue
    cd "${FAKE_REPO}/${wrapper%/*}" || exit 1
    touch match-me.yaml
    : > "${STUB_LOG}"
    "./${wrapper##*/}" --extra-values "my values.yaml" "*.yaml" > /dev/null 2>&1
    mapfile -t logged < "${STUB_LOG}"
    line=${logged[0]:-}
    [[ "${line}" == *" --extra-values my\\ values.yaml \\*.yaml" ]] || failures+=("${wrapper}: ${line}")
  done
  assert_equal "$(printf '%s\n' "${failures[@]}")" ""
}

@test "the not-plain wrappers all exist" {
  local wrapper
  for wrapper in "${NOT_PLAIN[@]}"; do
    assert [ -f "${REPO_ROOT}/${wrapper}" ]
  done
}

@test "kubernetes/undeploy-k8s.sh deletes its manifests from kube-system, but keeps the namespace" {
  copy_into_repo kubernetes/undeploy-k8s.sh
  local dir="${FAKE_REPO}/kubernetes"
  mkdir -p "${dir}/extra-manifests" && touch "${dir}/extra-manifests/b.yaml" "${dir}/extra-manifests/a.yaml"
  cd "${dir}" || exit 1
  run ./undeploy-k8s.sh
  assert_success
  assert_stub_calls \
    "kubectl delete -f ./extra-manifests/a.yaml -n kube-system --ignore-not-found" \
    "kubectl delete -f ./extra-manifests/b.yaml -n kube-system --ignore-not-found"
}

@test "Calico Whisker's undeploy deletes its manifests and its generated TLS secrets" {
  copy_into_repo monitoring/ebpf/calico-whisker/undeploy-k8s.sh
  local dir="${FAKE_REPO}/monitoring/ebpf/calico-whisker"
  mkdir -p "${dir}/extra-manifests" && touch "${dir}/extra-manifests/a.yaml"
  cd "${dir}" || exit 1
  run ./undeploy-k8s.sh
  assert_success
  assert_stub_calls \
    "kubectl delete -f ./extra-manifests/a.yaml -n kube-system --ignore-not-found" \
    "kubectl -n kube-system delete secret goldmane-tls whisker-backend-tls whisker-cert-secret --ignore-not-found"
}

@test "the kubectl-only undeploys fail when a delete fails, after trying everything" {
  make_stub_script kubectl '[[ " $* " == *broken* ]] && exit 1; exit 0'
  copy_into_repo kubernetes/undeploy-k8s.sh monitoring/ebpf/calico-whisker/undeploy-k8s.sh
  local dir
  for dir in "${FAKE_REPO}/kubernetes" "${FAKE_REPO}/monitoring/ebpf/calico-whisker"; do
    mkdir -p "${dir}/extra-manifests" && touch "${dir}/extra-manifests/0-broken.yaml"
    cd "${dir}" || exit 1
    run ./undeploy-k8s.sh
    assert_failure 1
    rm "${dir}/extra-manifests/0-broken.yaml"
  done
  make_stub kubectl
}
