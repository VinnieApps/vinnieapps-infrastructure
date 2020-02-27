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

while [ "$ip_address" == "" ] || [ "$ip_address" == "null" ]; do
  echo "Waiting for envoy service's IP address..."
  sleep 5
  ip_address=$(kubectl get svc envoy --ignore-not-found -n projectcontour -oJSON | jq -r '.status.loadBalancer.ingress[0].ip')
done
echo "Service found: '$ip_address', moving on."

terraform init -backend-config="bucket=$BUCKET_NAME"
terraform apply -auto-approve
