# Secret management

Handling secrets centrally and securely is very important to keep them safe and private/encrypted.

## Requirements

- Free and Open source, preferably 0$ cost
- Ability to handle many secrets
  - Ansible inventories: whole or parts of it (IPs, keys, passwords)
  - Terraform tfstate and tfvars
  - Helm Chart values.yamls: The private ones
  - Docker compose .env variables
- For secret detection, ability to add it as a git pre-commit hook

## Contenders

- [SOPS](https://github.com/getsops/sops), [age](https://github.com/FiloSottile/age) and VSCode integration - A robust albeit half-manual way
- [Dotenvx](https://dotenvx.com/) - Docker compose .env files encryption
- [Infisical](https://infisical.com/) - A full stack of a secret management with integration into many platforms
- [HashiCorp Vault](https://www.hashicorp.com/en/products/vault) - A Corporate solution to secret management, pricey for homelabbers
- [OpenBao](https://openbao.org/) - An open-source alternative to Vault
- [GitLeaks](https://github.com/gitleaks/gitleaks) - Detect secrets in git repos
- [TruffleHog](https://github.com/trufflesecurity/trufflehog) - Find leaked credentials
- [detect-secrets](https://github.com/Yelp/detect-secrets)

## Usage

### Ansible inventory setup

Variables that are shared more widely than this group of Apps are not listed here, but in the more generic README files higher up in the folder structure. Only the variables shared by the Apps of this group are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
