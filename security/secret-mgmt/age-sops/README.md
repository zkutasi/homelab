# SOPS & age

SOPS and age are tools to be used to protect secrets but still able to commit them in git repos for example so version-controlling them too.

- Official site:
  - [SOPS](https://getsops.io/)
- Source repository:
  - [SOPS](https://github.com/getsops/sops)
  - [age](https://github.com/FiloSottile/age)
- Documentation:
  - [SOPS](https://getsops.io/docs/)
- ~~Image repo~~
- ~~Other sites~~

## The setup

The host that handles the git repo (the control server) has SOPS and age installed, and holds the age key in `~/.sops/age.key`.

- Every file with `private` in its name holds secrets and is ignored by git. When it has to be kept in the repository, its SOPS-encrypted copy is committed next to it with the `_encrypted` suffix.
- Files are encrypted as a whole (SOPS binary mode), so a decrypted copy is byte for byte identical to the original.
- The recipient of every encrypted file is the public key that `sops.sh` derives from the age key with `age-keygen`.
- `SOPS_AGE_KEY_FILE` points SOPS and `sops.sh` to the age key. It is exported in `~/.bash_aliases`, so it is only set in interactive shells.
- A git pre-commit hook runs `sops.sh --decrypt-all` before every commit, and fails when a plaintext file differs from its encrypted copy, or when `SOPS_AGE_KEY_FILE` is not set.

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook security/secret-mgmt/age-sops/deploy-age.yaml --no-check
    ./common-ansible-run-playbook.sh --playbook security/secret-mgmt/age-sops/deploy-sops.yaml --no-check
    ```

### Post deployment

1. Configure age: it generates the age key if there is none yet, and exports `SOPS_AGE_KEY_FILE` in `~/.bash_aliases`

    ```bash
    ./common-ansible-run-playbook.sh --playbook security/secret-mgmt/age-sops/configure-age.yaml --no-check
    ```

2. Open a new shell, so `SOPS_AGE_KEY_FILE` is set

3. Back up `~/.sops/age.key` to a safe place outside this host (e.g. a password manager). It is the only key that can decrypt the `_encrypted` files; without it they are lost for good.

## Metrics, Alerts, Notifications

## Commands

To encrypt or decrypt, use the helper script `sops.sh`. It always needs a mode, and `--help` lists them all.

|Command|What it does|
|-------|------------|
|`sops.sh --encrypt <file>`|Encrypts one file into `<file>_encrypted`|
|`sops.sh --decrypt <file>_encrypted`|Decrypts one file next to it, without the suffix|
|`sops.sh --encrypt-all`|Encrypts every private file, skipping the ones whose content did not change|
|`sops.sh --decrypt-all`|Decrypts every missing plaintext file, and checks the existing ones against their encrypted copy (what the pre-commit hook runs)|
|`sops.sh --reencrypt-all`|Re-encrypts every encrypted file whose plaintext has changed|
|`sops.sh --redecrypt-all`|Recreates every plaintext file from its encrypted copy, overwriting local changes|

## Notable comments

- Besides `sops`, `sops.sh` needs `age-keygen` (installed together with age) to derive the public key.
- After changing a private file, run `sops.sh --encrypt-all` (or `--reencrypt-all`) before committing, otherwise the pre-commit hook stops the commit.
- After a fresh clone, run `sops.sh --decrypt-all` to get all plaintext files.
- Commits from GUI git clients (e.g. VS Code) fail the pre-commit hook, as they don't load `~/.bash_aliases`. Commit from a terminal instead.
- On a new control server, restore the backed-up key to `~/.sops/age.key` before running `configure-age.yaml`: the playbook only creates a key when there is none, and a newly created key cannot decrypt the existing files.
