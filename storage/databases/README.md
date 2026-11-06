# Database tools

Backup handling, queries, traversal, remote connectivity and much more.

## Requirements

- Free and Open source, preferably 0$ cost

## Contenders

- [Adminer](https://www.adminer.org/) - Database management in a single PHP file
- [dbgate](https://www.dbgate.io/) - Database manager for MySQL, PostgreSQL, SQL Server, MongoDB, SQLite and others. Runs under Windows, Linux, Mac or as web application
- [Databasus](https://databasus.com/) - PostgreSQL backup tool with Point-In-Time-Recovery and restore verification
- [Portabase](https://portabase.io/) - Database backup & restore tool for PostgreSQL, MySQL, MsSQL, MariaDB, Firebird SQL, SQLite, MongoDB, Redis, Files and Docker Volume

## Usage

### Ansible inventory setup

Variables that are shared more widely than this group of Apps are not listed here, but in the more generic README files higher up in the folder structure. Only the variables shared by the Apps of this group are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
