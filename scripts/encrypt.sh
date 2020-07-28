#!/bin/bash

set -e

PASSWORD=$(gpg2 --gen-random --armor 1 40)
FILE_TO_ENCRYPT=encrypted.taz.gz
ENCRYPTED_FILE=encrypted.taz.gz.gpg

rm -f $FILE_TO_ENCRYPT $ENCRYPTED_FILE
tar -czvf $FILE_TO_ENCRYPT \
  credentials.json

gpg2 --symmetric --batch --yes --passphrase "$PASSWORD" $FILE_TO_ENCRYPT
md5 $FILE_TO_ENCRYPT
md5 $ENCRYPTED_FILE

echo "Your password is: $PASSWORD"
