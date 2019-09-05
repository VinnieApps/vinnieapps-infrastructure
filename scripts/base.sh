#!/bin/bash

function usage() {
    echo "Usage:"
    echo "   ./deploy_functions.sh {project_id} {environment}"
    echo
    echo "  project_id      Google Cloud Project to deploy the function to."
    echo "  environment     Name of the environment that will be created."
}

if [ -z "$1" ]; then
    usage
    exit 1
fi

if [ -z "$2" ]; then
    usage
    exit 1
fi

GIT_SHA=$(git rev-parse --short HEAD)
PROJECT=$1
ENVIRONMENT=$2

INFRA_DIR=./terraform/$ENVIRONMENT

echo "+---------------------------------------------------------+"
echo "| Git SHA:            $GIT_SHA"
echo "| Environment:        $ENVIRONMENT"
echo "| Infrastructure Dir: $INFRA_DIR"
echo "+---------------------------------------------------------+"
