#!/bin/bash

set -e

PASSWORD=$(gpg2 --gen-random --armor 1 40)
FILE_TO_ENCRYPT=encrypted.taz.gz
ENCRYPTED_FILE=encrypted.taz.gz.gpg

rm -f $FILE_TO_ENCRYPT $ENCRYPTED_FILE
tar -czvf $FILE_TO_ENCRYPT \
  environments/dev/cert.pem \
  environments/dev/privkey.pem \
  environments/dev/credentials.json \
  environments/dev/01-base/terraform.tfvars \
  environments/dev/03-applications/terraform.tfvars

gpg2 --symmetric --batch --yes --passphrase "$PASSWORD" $FILE_TO_ENCRYPT
md5 $FILE_TO_ENCRYPT
md5 $ENCRYPTED_FILE

echo "Your password is: $PASSWORD"
