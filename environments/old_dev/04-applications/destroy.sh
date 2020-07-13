#!/bin/bash

kubectl delete --ignore-not-found -f 001-photos-http-proxy.yml

kubectl delete deployment -n photos --ignore-not-found photos-jobs
kubectl delete deployment -n photos --ignore-not-found photos-service
