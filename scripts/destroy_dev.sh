#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BASE_DIR=$(pwd $SCRIPT_DIR/..)

cd $BASE_DIR/environments/dev

cd '04 - applications'
kubectl delete -f 001-photos.yml
cd ../

cd '03 - applications'
terraform destroy -auto-approve
cd ../

cd '02 - kubernetes'
kubectl delete -f 001-contour.yml
cd ../

cd '01 - base'
terraform destroy -auto-approve
cd ../
