#!/bin/bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source $SCRIPT_DIR/base.sh

pushd $INFRA_DIR > /dev/null
terraform init
terraform apply -var "project_id=$PROJECT" -var "environment=$ENVIRONMENT"
popd > /dev/null
