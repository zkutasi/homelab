# What You Get is What You Have (WYGIWYH)

[WYGIWYH](https://github.com/eitchtee/WYGIWYH) - A no-budget approach to expense tracking. Just (periodically) import your CSVs (do not forget to pre-create most things you need) and glance at the Sankey diagram.

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |wygiwyh_database_password|M||
    |wygiwyh_secret_key|M||
    |wygiwyh_url|M|The full used URL in the browser, for CSRF protection, hostname part only|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook finance/wygiwyh/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

1. Create the superuser account:

    ```bash
    kubectl -n wygiwyh exec -ti deployment/wygiwyh -c wygiwyh -- python manage.py createsuperuser
    ```

2. On the UI, create some things before any Import could happen:

    1. Categories to put transactions into
    2. Currencies for the Accounts
    3. Accounts for the Transactions
    4. Rules for the Transactions
    5. Import profile for the CSV imports

## Commands

## Notable comments

- This is my import profile:

    ```yaml
    settings:
      file_type: csv
      delimiter: ","
      encoding: utf-16
      skip_lines: 0
      importing: transactions
      trigger_transaction_rules: true
      skip_errors: false
    mapping:
      account:
        target: account
        source: "Felhasználónév"
        required: true
        transformations:
          - type: replace
            pattern: "Erste FőSzámla"
            replacement: "Erste Main Account"
          - type: replace
            pattern: "KUTASI ZOLTÁN"
            replacement: "Erste Credit Card"
      type:
        target: type
        source: "Összeg"
        detection_method: sign
      is_paid:
        target: is_paid
        detection_method: always_paid
      date:
        target: date
        required: true
        format:
          - "%Y.%m.%d"
          - "%Y.%m.%d %H:%M:%S"
        transformations:
          - type: merge
            fields:
              - "Tranzakció dátuma és ideje"
              - "Könyvelés dátuma"
            separator: "____"
          - type: regex
            pattern: "(?<=^\\d{4}\\.\\d{2}\\.\\d{2} \\d{2}:\\d{2}:\\d{2})____.*|^____"
            replacement: ""
            exclusive: false
      reference_date:
        target: reference_date
        required: true
        format:
          - "%Y.%m.%d"
          - "%Y.%m.%d %H:%M:%S"
        transformations:
          - type: merge
            fields:
              - "Tranzakció dátuma és ideje"
              - "Könyvelés dátuma"
            separator: "____"
          - type: regex
            pattern: "(?<=^\\d{4}\\.\\d{2}\\.\\d{2} \\d{2}:\\d{2}:\\d{2})____.*|^____"
            replacement: ""
            exclusive: false
      amount:
        target: amount
        source: "Összeg"
        required: true
        transformations:
          - type: replace
            pattern: " "
            replacement: ""
      description:
        target: description
        source: "Könyvelési információk"
        default:
        required: false
      entities:
        target: entities
        source: "Partner név"
        required: false
        create: true
        type: name
      internal_id:
        target: internal_id
        transformations:
          - type: hash
            fields:
              - "Könyvelés dátuma"
              - "Összeg"
              - "Partner név"
              - "Könyvelési információk"
              - "Tranzakcióazonosító"
              - "Tranzakció dátuma és ideje"
    deduplication:
      - type: compare
        fields:
          - internal_id
        match_type: strict

    ```
