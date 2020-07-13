#!/bin/bash

set -e

usage() {
    echo "Usage:"
    echo "   ./create_dev.sh {GCP_PROJECT} {BUCKET_NAME}"
    echo
    echo "  GCP_PROJECT      Project ID to use in GCP."
    echo "  BUCKET_NAME      Bucket name in GCP to store terraform states in."
}

if [ -z "$2" ]; then
    usage
    exit 1
fi

GCP_PROJECT=$1
BUCKET_NAME=$2

echo "Creating environment, starting at: $(date)"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BASE_DIR=$(pwd $SCRIPT_DIR/..)

cd $BASE_DIR/environments/dev

cd '01-base'
./create.sh $GCP_PROJECT $BUCKET_NAME
cd ../

# cd '02-kubernetes'
# ./create.sh
# cd ../

# cd '03-applications'
# ./create.sh $BUCKET_NAME
# cd ../

# cd '04-applications'
# ./create.sh $GCP_PROJECT
# cd ../

echo "Done, the time is: $(date)"
