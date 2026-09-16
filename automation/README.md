# Automation tools

Managing multiple hosts, being VMs, VPS-es or baremetal is a challenge. Making sure they are up-to-date, configured properly and equally, or even redo them in case of a reinstall/migration. Some tools are required, especially for scheduling.

## Requirements

- Free and Open source, preferably 0$ cost
- Infrastructure as Code (IaC): commit the declarative or imperative steps and the tool should just do/achieve
- Schedule through a webUI, but command line execution shall be also possible

## Contenders

### IaC

- [Ansible](https://docs.ansible.com/) - Ansible is a radically simple IT automation platform that makes your applications and systems easier to deploy and maintain. Automate everything from code deployment to network configuration to cloud management, in a language that approaches plain English, using SSH, with no agents to install on remote systems.
- [Terraform](https://developer.hashicorp.com/terraform) - Terraform enables you to safely and predictably create, change, and improve infrastructure. It is a source-available tool that codifies APIs into declarative configuration files that can be shared amongst team members, treated as code, edited, reviewed, and versioned.
  - Open source version is [OpenTofu](https://opentofu.org/)
- [Pulumi](https://www.pulumi.com/)
- [Salt](https://saltproject.io/)
- [Chef](https://www.chef.io/products/chef-infra)
- [Puppet](https://www.puppet.com/)

### WebUI

If one needs to have a WebUI, to manage the workflows, create and run repeated procedures.

- [Jenkins](https://www.jenkins.io/) - Industry standard CI tool to automate almost anything
- [Semaphore UI](https://semaphoreui.com/) - Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt, PowerShell and other DevOps tools.
- [Ansible Automation Platform (AAP)](https://www.redhat.com/en/technologies/management/ansible) - Enterprise solution for automating Ansible. Formerly known as **Ansible Tower** or **Ansible Controller**.
  - Red Hat upstream project is [AWX](https://github.com/ansible/awx) - WebUI REST API and Task Engine on top of Ansible. On hold in 2024 due to a major refactor. Also a very complex setup is required and to keep up-to-date.
- [Rundeck](https://www.rundeck.com/) - Often comes up as an alternative to the above UIs
- [Kestra](https://kestra.io/) - Open Source, declarative Orchestration Platform, capable to many more things, like data-pipelines too, but also can run Ansible playbooks.

### Other

- [OliveTin](https://olivetin.app/) - OliveTin gives safe and simple access to predefined shell commands from a web interface.
