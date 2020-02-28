#!/bin/bash

set -e

usage() {
    echo "Usage:"
    echo "   ./build_docker_create.sh {PASSPHRASE}"
    echo
    echo "  PASSPHRASE      Passphrase used to decrypt secrets file."
}

if [ -z "$1" ]; then
    usage
    exit 1
fi

PASSPHRASE=$1

./scripts/decrypt.sh $PASSPHRASE

# Setup Google Cloud tools
gcloud auth activate-service-account --key-file=environments/dev/credentials.json
gcloud config set compute/zone us-east1-b
gcloud config set project vinnieapps

./scripts/create_dev.sh vinnieapps tf-state-dev-vinnieapps
