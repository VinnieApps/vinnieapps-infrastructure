#!/bin/bash

set -e

usage() {
    echo "Usage:"
    echo "   ./destroy.sh {GCP_PROJECT} {BUCKET_NAME}"
    echo
    echo "  BUCKET_NAME      Bucket name in GCP to store terraform states in."
    echo "  GCP_PROJECT      Project ID to use in GCP."
}

if [ -z "$2" ]; then
    usage
    exit 1
fi

BUCKET_NAME=$2
GCP_PROJECT=$1

terraform init -backend-config="bucket=$BUCKET_NAME"
terraform destroy -auto-approve -var 'environment=dev' -var "project_id=$GCP_PROJECT"
