# Automation tools

Managing multiple hosts, being VMs, VPS-es or baremetal is a challenge. Making sure they are up-to-date, configured properly and equally, or even redo them in case of a reinstall/migration. Some tools are required, especially for scheduling.

## Requirements

- Free and Open source, preferably 0$ cost
- Infrastructure as Code (IaC): commit the declarative or imperative steps and the tool should just do/achieve
- Schedule through a webUI, but command line execution shall be also possible

## Contenders

### IaC

- [Ansible](https://docs.ansible.com/) - A python-based tool from RedHat, somewhat an industry standard now. Configured in YAML, and it has literally 100s of plugins. More tailored to set up a host (config, software install, file contents, etc...)
- [Terraform](https://developer.hashicorp.com/terraform) - From HashiCorp, another industry standard. More focusing on creating VMs and managing execution environments.
  - Open source version is [OpenTofu](https://opentofu.org/)
- [Pulumi](https://www.pulumi.com/)
- [Salt](https://saltproject.io/)
- [Chef](https://www.chef.io/products/chef-infra)
- [Puppet](https://www.puppet.com/)

### WebUI

If one needs to have a WebUI, to manage the workflows, create and run repeated procedures.

- [Jenkins](https://www.jenkins.io/) - Industry standard CI tool to automate almost anything
- [Semaphore UI](https://semaphoreui.com/) - Run Ansible, Terraform, OpenTofu and Bash scripts
- [Ansible Automation Platform (AAP)](https://www.redhat.com/en/technologies/management/ansible) - Enterprise solution for automating Ansible. Formerly known as **Ansible Tower** or **Ansible Controller**.
  - Red Hat upstream project is [AWX](https://github.com/ansible/awx) - WebUI REST API and Task Engine on top of Ansible. On hold in 2024 due to a major refactor. Also a very complex setup is required and to keep up-to-date.
- [Rundeck](https://www.rundeck.com/) - Often comes up as an alternative to the above UIs
- [Kestra](https://kestra.io/) - Open Source, declarative Orchestration Platform, capable to many more things, like data-pipelines too, but also can run Ansible playbooks.
