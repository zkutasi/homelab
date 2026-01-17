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
