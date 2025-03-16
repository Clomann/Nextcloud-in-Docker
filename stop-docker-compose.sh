#!/bin/bash

ENV_FILE=conf.env

cd "$(dirname "$0")"

# Ensure conf.env exists
if [[ ! -f "$ENV_FILE" ]]; then
    echo "Error: $ENV_FILE not found!"
    exit 1
fi

# Load environment variables
set -a  # Automatically export all variables
source "$ENV_FILE"
set +a  # Stop automatically exporting

docker compose down