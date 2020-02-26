#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BASE_DIR=$(pwd $SCRIPT_DIR/..)

cd $BASE_DIR/environments/dev

cd '01 - base'
terraform apply -auto-approve
gcloud container clusters get-credentials primary-dev
cd ../

cd '02 - kubernetes'
kubectl apply -f 001-contour.yml
cd ../

while [ "$ip_address" == "" ] || [ "$ip_address" == "null" ]; do
  echo "Waiting for envoy service's IP address..."
  sleep 5
  ip_address=$(kubectl get svc envoy --ignore-not-found -n projectcontour -oJSON | jq -r '.status.loadBalancer.ingress[0].ip')
done
echo "Service found: '$ip_address', moving on."

cd '03 - applications'
terraform apply -auto-approve
cd ../

cd '04 - applications'
./create.sh vinnieapps
cd ../
