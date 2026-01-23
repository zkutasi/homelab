# Password management

Everything requires passwords nowadays. Apps, banks, services, websites. Relying on 3rd parties is a good way to handle multiple devices, but depending on where that 3rd party is, things get messy: Is it a browser tool, then what happens if you need to change browsers? If it is a cloud service, trust issues emerge (or what if the cloud is down, not so rare nowadays). Selfhosting a password manager solves this issue.

## Requirements

- Free and Open source, preferably 0$ cost
- Sync passwords on multiple devices
- Autofill from browser or potentially from other apps, terminals as well

## Contenders

- [Bitwarden](https://bitwarden.com/) - The most trusted password manager. Has a free tier. Quite complex, with officially ~10 docker images running, though there is a unified container as well.
- [VaultWarden](https://github.com/dani-garcia/vaultwarden) - An alternative server implementation of the Bitwarden Client API, written in Rust and compatible with official Bitwarden clients, perfect for self-hosted deployment where running the official resource-heavy service might not be ideal.
- [Passbolt](https://www.passbolt.com/) - Passbolt is a free and open source password manager that allows team members to store and share credentials securely.
- [KeepassXC](https://keepassxc.org/) - A cross-platform community-driven port of the Windows application “KeePass Password Safe”. It saves many different types of information, such as usernames, passwords, URLs, attachments, and notes in an offline, encrypted file that can be stored in any location, including private and public cloud solutions. It is just an App, no server component is there.
