#!/bin/bash

set -e

usage() {
    echo "Usage:"
    echo "   ./create_dev.sh {BUCKET_NAME}"
    echo
    echo "  BUCKET_NAME      Bucket name in GCP to store terraform states in."
}

if [ -z "$1" ]; then
    usage
    exit 1
fi

BUCKET_NAME=$1

terraform init -backend-config="bucket=$BUCKET_NAME"
terraform apply -auto-approve
gcloud container clusters get-credentials primary-dev
