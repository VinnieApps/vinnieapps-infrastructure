#!/bin/bash

if [ ! -d letsencrypt ]; then
  mkdir letsencrypt
fi

pushd letsencrypt >> /dev/null

docker run -it --name certbot \
  -v 'etc:/etc/letsencrypt' \
  -v 'lib:/var/lib/letsencrypt' \
  certbot/certbot certonly --manual --preferred-challenges dns

if [ ! -d etc ]; then
  mkdir etc
fi

docker cp certbot:/etc/letsencrypt/ etc/

docker container rm certbot

popd >> /dev/null
