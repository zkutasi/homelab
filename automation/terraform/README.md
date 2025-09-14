# Terraform

[Terraform](https://developer.hashicorp.com/terraform). Infrastructure as Code mainly to handle Virtual machines and Provisioning them.

Recently in 2025 there was a big shift in the license const of this tool, so if you still want to use it in the future, probably a good way to go is to look into [OpenTofu](https://opentofu.org/). It still uses the same language to write the IaC, and is completely still open source.

## The setup

I run a 3-Node Proxmox cluster, where I have a Kubernetes cluster in 3+3 VMs. Handling the VM Provisioning was done using Terraform.

The creatable objects are in the `main.tf` file.

The `vars.tf` file holds the schema for the config you need to pass in (see later).

## Prerequisites

- A few VMs or Hosts for Nodes
- Proxmox is set up with the required roles and settings for Terraform

## Usage

1. Create the configuration files: Create file `terraform.tfvars`, with the following required content

    | Variable | Description |
    |----------|-------------|
    |pves|A list of Proxmox Virtual Environments (PVE), with `name` and `address` (IP) fields|
    |endpoint|The PVE system's entry HTTP address|
    |api_token|The Terraform user's Proxmox API token, created beforehand|
    |k8s_controllers|A list of Kubernetes controller Hosts, with fields `address` (IP/mask), `cpu`, `disk`, `memory`, `name` (hostname), `node_name` (which PVE should have this VM) and `vm_id`|
    |k8s_worker|A list of Kubernetes worker hosts. Same fields are valid as for controlers. Additional fields: `disk_data`|
    |username|The username for the created VM Guest|
    |password|The password for the created user|

2. Run the terraform init command

    ```bash
    ./run-init.sh
    ```

3. Run terraform plan to see the execution plan, if it is syntactically correct even

    ```bash
    ./run-plan.sh
    ```

4. Run terraform apply to apply the plan

    ```bash
    ./run-apply.sh
    ```

## Commands

### Destroy things to start over

1. Run the full terraform destroy to remove everything, VMs, images, and config fragments included

    ```bash
    ./run-destroy.sh
    ```

2. Alternatively run the destroy VM only script to only delete the VMs and leave the images alone

    ```bash
    ./run-destroy-vm-only.sh
    ```

## Notable comments
