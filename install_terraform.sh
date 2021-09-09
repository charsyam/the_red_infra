#!/bin/bash

VERSION=1.0.1
case "$OSTYPE" in
    darwin*) FILENAME="darwin_amd64" ;;
    *)       FILENAME="linux_amd64" ;;
esac

TERRAFORM_FILENAME=terraform_${VERSION}_${FILENAME}.zip
TERRAFORM_URL=https://releases.hashicorp.com/terraform/${VERSION}/${TERRAFORM_FILENAME}
mkdir tmp
cd tmp
wget $TERRAFORM_URL
unzip ./${TERRAFORM_FILENAME}
sudo cp terraform /usr/local/bin
cd ..
rm -rf ./tmp
