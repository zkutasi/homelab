# Clasp

[Clasp](https://github.com/google/clasp) is a CLI interface towards your Google App Scripts (GAS). Handle them git-like.

## The setup

Clasp requires NodeJS, so it is best to enclose it in a docker container. The container makes the CLI available, where one can login, clone, push, pull, etc. There is no readily available docker image, so we build our own little Node container.

## Prerequisites

## Ansible inventory setup

No special setup is required.

## Usage

```bash
./run-playbook.sh --playbook playbooks/selfhosting/clasp/deploy-clasp.yaml --no-check
```

## Commands

1. Enable the API in the [App Scripts User Settings](https://script.google.com/home/usersettings).
   1. Also enable if required in the [Coogle Cloud Console](https://console.cloud.google.com), navigating into Dashboard -> Enable API Services -> App Scripts API

2. Create an Oauth ID
   1. Navigate to [Your Coogle Cloud Console](https://console.cloud.google.com), then Dashboard -> Credentials and Create a new Oauth CLient ID. Type shall be Desktop App.
   2. Be sure to download the client-secret.json, because this is the last time you can do that.
   3. Place this JSON file next to the container, to be ready for the login command to access it.

3. Get some info
   1. PROJECT_ID: Go to [Your Coogle Cloud Console](https://console.cloud.google.com), then select your Project at the top. The ID can be found in the table, or if you click into it, next to many other data.
   2. SCRIPT_ID: Go to [Your App Scripts](https://script.google.com), then navigate to your script. The ID can be found in the Browser navigation bar

4. Login to the Google Cloud

    ```bash
    docker compose run -ti --rm clasp login --creds /root/email-events-client-secret.json --no-localhost
    ```

    Copy the URL into a browser, enable the things you would like your App to access, then when the Browser redirects you to some localhost URL, copy that URL back into the App, press enter, and you should be logged in. A file of `.clasprc.json` should be created to persist your credentials accross docker-compose sessions.

5. Clone the GAS project of your liking

    ```bash
    docker compose run --rm clasp clone SCRIPT_ID --rootDir /gas
    ```

    Now your given script you developed on the UI is accessible locally.

## Notable comments

- At least node:20 was required, earlier ones could not login
- There is an bigger ongoing change for clasp 3.0, but that one is in Alpha now (2025-07), so be sure to read the readme for the 2.5.0 version (lates of date)
- The file `.clasprc.json` is created in the container user's home folder, which is `/root`, so this is why the config folder is mounted into this one, to get access to this generated file.
