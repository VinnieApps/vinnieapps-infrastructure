#!/bin/bash

set -e

usage() {
    echo "Usage:"
    echo "   ./decrypt.sh {PASSPHRASE}"
    echo
    echo "  PASSPHRASE      Password to decrypt the files."
}

if [ -z "$1" ]; then
    usage
    exit 1
fi

PASSPHRASE=$1
ENCRYPTED_FILE=encrypted.taz.gz.gpg
ORIGINAL_FILE=encrypted.taz.gz

if [ -f $ORIGINAL_FILE ]; then
  echo "Original file present, backing it up..."
  mv $ORIGINAL_FILE $ORIGINAL_FILE.$(date +%s)
fi

gpg2 -d --output $ORIGINAL_FILE --passphrase "$PASSPHRASE" --yes --batch $ENCRYPTED_FILE

tar -xzvf encrypted.taz.gz
