#!/usr/bin/env bats
# The thin run scripts: Terraform's commands, and the Ansible pings and fact gathering, which run through
# ansible-navigator when it's there, else through ansible
# covers: automation/terraform/run-*.sh
# covers: automation/ansible/run-ping.sh automation/ansible/run-fact-gathering.sh
# covers: kubernetes/k8s-install/kubespray/run-ping.sh

load helpers

ANSIBLE_DIR=automation/ansible
KUBESPRAY=kubernetes/k8s-install/kubespray

setup() {
  setup_fake_repo
}

@test "each Terraform script runs its command" {
  local command
  copy_into_repo automation/terraform/run-{init,plan,apply,destroy}.sh
  make_stub terraform
  cd "${FAKE_REPO}/automation/terraform" || exit 1
  for command in init plan apply destroy; do
    run "./run-${command}.sh"
    assert_success
  done
  assert_stub_calls "terraform init" "terraform plan" "terraform apply" "terraform destroy"
}

@test "run-destroy-vm-only.sh destroys the controller VMs, then the worker VMs" {
  copy_into_repo automation/terraform/run-destroy-vm-only.sh
  make_stub terraform
  cd "${FAKE_REPO}/automation/terraform" || exit 1
  run ./run-destroy-vm-only.sh
  assert_success
  assert_stub_calls \
    "terraform destroy -target=proxmox_virtual_environment_vm.k8s_controller_vm" \
    "terraform destroy -target=proxmox_virtual_environment_vm.k8s_worker_vm"
}

@test "a failing Terraform command fails its script with the same exit code" {
  copy_into_repo automation/terraform/run-plan.sh
  make_stub terraform 2
  cd "${FAKE_REPO}/automation/terraform" || exit 1
  run ./run-plan.sh
  assert_failure 2
}

@test "run-ping.sh pings the Linux, then the Windows hosts through ansible-navigator, with the repository's config" {
  copy_into_repo "${ANSIBLE_DIR}/run-ping.sh"
  STUB_ENV_VARS=ANSIBLE_NAVIGATOR_CONFIG make_stub ansible-navigator
  cd "${FAKE_REPO}/${ANSIBLE_DIR}" || exit 1
  run ./run-ping.sh
  assert_success
  assert_stub_calls \
    "ansible-navigator exec -- ansible --inventory homelab-ansible-inventory/inventory -m ping --limit linux all" \
    "ANSIBLE_NAVIGATOR_CONFIG=${FAKE_REPO}/.ansible-navigator.yaml" \
    "ansible-navigator exec -- ansible --inventory homelab-ansible-inventory/inventory -m ansible.windows.win_ping --limit windows all" \
    "ANSIBLE_NAVIGATOR_CONFIG=${FAKE_REPO}/.ansible-navigator.yaml"
}

@test "run-ping.sh uses ansible without ansible-navigator, and fails without either" {
  copy_into_repo "${ANSIBLE_DIR}/run-ping.sh"
  cd "${FAKE_REPO}/${ANSIBLE_DIR}" || exit 1
  run ./run-ping.sh
  assert_failure 1
  assert_line "ERROR: neither ansible-navigator nor ansible is available"
  make_stub ansible
  run ./run-ping.sh
  assert_success
  assert_stub_calls \
    "ansible --inventory homelab-ansible-inventory/inventory -m ping --limit linux all" \
    "ansible --inventory homelab-ansible-inventory/inventory -m ansible.windows.win_ping --limit windows all"
}

@test "run-fact-gathering.sh gathers the facts of exactly one host" {
  copy_into_repo "${ANSIBLE_DIR}/run-fact-gathering.sh"
  make_stub ansible
  cd "${FAKE_REPO}/${ANSIBLE_DIR}" || exit 1
  run ./run-fact-gathering.sh
  assert_failure 1
  assert_line "ERROR: No host specified"
  run ./run-fact-gathering.sh host1 host2
  assert_failure 1
  assert_line "ERROR: only one host can be given"
  assert_stub_not_called ansible
  run ./run-fact-gathering.sh host1
  assert_success
  assert_stub_calls "ansible host1 --inventory homelab-ansible-inventory/inventory -m setup"
}

@test "Kubespray's run-ping.sh pings its inventory with Kubespray's ansible.cfg, from its own folder only" {
  copy_into_repo "${KUBESPRAY}/run-ping.sh"
  STUB_ENV_VARS=ANSIBLE_CONFIG make_stub ansible
  local dir="${FAKE_REPO}/${KUBESPRAY}"
  cd "${FAKE_REPO}" || exit 1
  run "${dir}/run-ping.sh"
  assert_failure 1
  assert_output --partial "ERROR: Run run-ping.sh from its own folder"
  cd "${dir}" || exit 1
  run ./run-ping.sh
  assert_failure 1
  assert_output --partial "ERROR: No kubespray-repo folder here"
  mkdir -p kubespray-repo && touch kubespray-repo/ansible.cfg
  run ./run-ping.sh
  assert_success
  assert_stub_calls "ansible --inventory inventory/hosts.yaml -m ping all" "ANSIBLE_CONFIG=${dir}/kubespray-repo/ansible.cfg"
}

@test "Kubespray's run-ping.sh passes Kubespray's ansible.cfg into ansible-navigator's container" {
  copy_into_repo "${KUBESPRAY}/run-ping.sh"
  make_stub ansible-navigator
  local dir="${FAKE_REPO}/${KUBESPRAY}"
  mkdir -p "${dir}/kubespray-repo" && touch "${dir}/kubespray-repo/ansible.cfg"
  cd "${dir}" || exit 1
  run ./run-ping.sh
  assert_success
  assert_stub_calls "ansible-navigator exec --set-environment-variable ANSIBLE_CONFIG=${dir}/kubespray-repo/ansible.cfg -- ansible --inventory inventory/hosts.yaml -m ping all"
}

@test "the Ansible run scripts refuse unknown options" {
  local script
  copy_into_repo "${ANSIBLE_DIR}/run-ping.sh" "${ANSIBLE_DIR}/run-fact-gathering.sh" "${KUBESPRAY}/run-ping.sh"
  make_stub ansible
  for script in "${ANSIBLE_DIR}/run-ping.sh" "${ANSIBLE_DIR}/run-fact-gathering.sh" "${KUBESPRAY}/run-ping.sh"; do
    cd "${FAKE_REPO}/$(dirname "${script}")" || exit 1
    run "./$(basename "${script}")" --force
    assert_failure 1
    assert_line 'ERROR: unknown parameter "--force"'
  done
  assert_stub_not_called ansible
}
