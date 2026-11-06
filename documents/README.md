# Document server

A centralized Application that holds all documents relevant to a household, being receipts, bills, tax forms or anything. Tags them, makes them searchable, retrievable, has built in OCR and even AI support.

## Requirements

- Free and Open source, preferably 0$ cost

## Contenders

- [Paperless NGX](https://github.com/paperless-ngx/paperless-ngx) - A community-supported supercharged document management system: scan, index and archive all your documents
  - [Apache Tika](https://tika.apache.org/) - Detects and extracts metadata and text from over a thousand different file types (such as PPT, XLS, and PDF).
  - [Gotenberg](https://gotenberg.dev/) - A developer-friendly API for converting many document formats into PDF files, and more!
- [Papra](https://github.com/papra-hq/papra) - The minimalistic document archiving platform.

## Usage

### Ansible inventory setup

Variables that are shared more widely than this group of Apps are not listed here, but in the more generic README files higher up in the folder structure. Only the variables shared by the Apps of this group are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
