#!/usr/bin/env bats
# The Helm post-renderers: each reads the rendered manifests on stdin and writes the changed ones to stdout
# covers: kubernetes/infrastructure/external-access/contour/kustomize.sh
# covers: monitoring/network/discovery/librenms/kustomize.sh
# covers: storage/s3/seaweedfs/all-in-one-replacements.sh

load helpers

CONTOUR=kubernetes/infrastructure/external-access/contour
LIBRENMS=monitoring/network/discovery/librenms
SEAWEEDFS=storage/s3/seaweedfs

setup() {
  setup_fake_repo
}

@test "Contour's adds the IPv4 DNS lookup to Envoy's init container and keeps the other manifests" {
  copy_into_repo "${CONTOUR}/kustomize.sh" "${CONTOUR}/kustomization.yaml"
  cd "${FAKE_REPO}/${CONTOUR}" || exit 1
  run ./kustomize.sh <<'MANIFESTS'
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: contour-envoy
spec:
  template:
    spec:
      initContainers:
        - name: envoy-initconfig
          args: [bootstrap]
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: contour
MANIFESTS
  assert_success
  run yq -r 'select(.kind == "DaemonSet") | .spec.template.spec.initContainers[0].args | join(" ")' <<< "${output}"
  assert_output "bootstrap --dns-lookup-family=v4"
  run ls "${FAKE_REPO}/${CONTOUR}"
  refute_line all.yaml
}

@test "Contour's fails with kustomize's exit code on broken input, and still removes the manifests it was given" {
  copy_into_repo "${CONTOUR}/kustomize.sh" "${CONTOUR}/kustomization.yaml"
  cd "${FAKE_REPO}/${CONTOUR}" || exit 1
  run ./kustomize.sh <<< "kind: [unclosed"
  assert_failure 1
  assert_output --partial "Error:"
  assert [ ! -e all.yaml ]
}

@test "LibreNMS's moves the scanner CronJob to batch/v1 and gives it the database password" {
  copy_into_repo "${LIBRENMS}/kustomize.sh" "${LIBRENMS}/kustomization.yaml"
  cd "${FAKE_REPO}/${LIBRENMS}" || exit 1
  run ./kustomize.sh <<'MANIFESTS'
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: librenms-snmp-scanner
spec:
  jobTemplate:
    spec:
      template:
        spec:
          containers:
            - name: scanner
MANIFESTS
  assert_success
  run yq -r '.apiVersion + " " + .spec.jobTemplate.spec.template.spec.containers[0].env[0].valueFrom.secretKeyRef.name' <<< "${output}"
  assert_output "batch/v1 librenms-mysql"
}

@test "SeaweedFS's points the filer's and the master's job labels to the all-in-one job, and leaves others alone" {
  copy_into_repo "${SEAWEEDFS}/all-in-one-replacements.sh"
  run "${FAKE_REPO}/${SEAWEEDFS}/all-in-one-replacements.sh" <<'MANIFESTS'
expr: up{job=\"seaweedfs-filer\"} == 0
expr: up{job=\"seaweedfs-master\"} == 0
expr: up{job=\"seaweedfs-volume\"} == 0
MANIFESTS
  assert_success
  assert_output 'expr: up{job=\"seaweedfs-all-in-one\"} == 0
expr: up{job=\"seaweedfs-all-in-one\"} == 0
expr: up{job=\"seaweedfs-volume\"} == 0'
}
