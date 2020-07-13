#!/bin/bash

set -e

usage() {
    echo "Usage:"
    echo "   ./create.sh {GCP_PROJECT} {BUCKET_NAME}"
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
terraform apply -auto-approve -var 'environment=dev' -var "project_id=$GCP_PROJECT"

IP_ADDRESS=$(gcloud compute instances describe dev-main-server --format='get(networkInterfaces[0].networkIP)')

## Wait for the machine to finish running init script
while [ "$ip_address" == "" ] || [ "$ip_address" == "null" ]; do
  echo "Waiting for dev server service's IP address..."
  sleep 5
  ip_address=$(kubectl get svc envoy --ignore-not-found -n projectcontour -oJSON | jq -r '.status.loadBalancer.ingress[0].ip')
done
echo "Service found: '$ip_address', moving on."