#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BASE_DIR=$(pwd $SCRIPT_DIR/..)

cd $BASE_DIR/environments/dev

cd '04 - applications'
./destroy.sh
cd ../

cd '03 - applications'
terraform destroy -auto-approve
cd ../

cd '02 - kubernetes'
kubectl delete --ignore-not-found -f 001-contour.yml
cd ../

cd '01 - base'
terraform destroy -auto-approve
cd ../
