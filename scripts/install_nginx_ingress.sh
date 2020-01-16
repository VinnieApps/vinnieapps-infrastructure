#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "Instlaling nginx ingress controller..."
kubectl apply -f $DIR/nginx-ingress

ip_address=$(kubectl get services -n ingress-nginx ingress-nginx -o=jsonpath='{.status.loadBalancer.ingress[*].ip}')
echo "Waiting for Ingress Service IP address..."
while [ -z "${ip_address}" ]; do
  ip_address=$(kubectl get services -n ingress-nginx ingress-nginx -o=jsonpath='{.status.loadBalancer.ingress[*].ip}')
  echo -n "."
  sleep 1
done

echo
echo "IP Address: ${ip_address}"
