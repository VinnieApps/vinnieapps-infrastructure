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

echo "Destroying environment, starting at: $(date)"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BASE_DIR=$(pwd $SCRIPT_DIR/..)

cd $BASE_DIR/environments/dev

cd '04-applications'
./destroy.sh
cd ../

cd '03-applications'
./destroy.sh $BUCKET_NAME
cd ../

cd '02-kubernetes'
./destroy.sh
cd ../

cd '01-base'
./destroy.sh $BUCKET_NAME
cd ../

echo "Done, the time is: $(date)"
