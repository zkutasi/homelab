# Karakeep

[Karakeep](https://example.com) - A self-hostable bookmark-everything app (links, notes and images) with AI-based automatic tagging and full text search.

## The setup

## Prerequisites

For Searching, meiliSearch is required as a separate container.

For proper web-crawling, a Chrome container is also required (for example to accept the EU cookie consents)

For AI tagging, Ollama or a public AI API is required.

## Usage

### Deploy the app

1. Create a values yaml file for potential private data named `app-values-private.yaml`

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
