# Komodo

[Official Site](https://komo.do/). A full build & deployment system.

## The setup

Run the Komodo server in Kubernetes and attach into the remote Docker hosts via Komodo's Periphery agent. No Kubernetes support yet though to manage those containers.

## Prerequisites

N/A

## Usage

1. Create a `.komodo.env` file with the following content

    ```env
    KOMODO_DATABASE_URI: mongodb://<USER>:<PASSWORD>@<HOST>:<PORT>/komodo
    KOMODO_PASSKEY: <RANDOM_STRING>
    KOMODO_DATABASE_USERNAME: <USER>
    KOMODO_DATABASE_PASSWORD: <PASSWORD>
    ```

2. Install with the provided script

    ```bash
    ./deploy.sh
    ```

3. After going to the URL, enter your wanted credentials and hit the "Sign Up" button

4. Deploy everywhere the Periphery docker container. Check the instructions in the ansible section for this.

## Commands

## Notable comments
