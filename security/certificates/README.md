# Certificates

The homelab's own root Certificate Authority (CA), used to issue the internal TLS certificates. All internal services use these certificates and CA.

## The setup

- `certs/ca.crt` - The public CA certificate. Load it as a trusted CA into the browsers and clients that access the homelab services.
- `certs/ca.key` - The private key of the CA.
- `internal-certs.sh` - Generates a new 4096-bit RSA key and a self-signed CA certificate, valid for 30 years.

## Usage

1. Generate the CA (only needed once)

    ```bash
    cd security/certificates/
    ./internal-certs.sh
    ```

2. Encrypt the private key with SOPS, so the encrypted version can be committed

## Notable comments

- Running `internal-certs.sh` again overwrites the existing CA. Every certificate issued from the old one stops being trusted, and the new `ca.crt` has to be redistributed to all clients.
