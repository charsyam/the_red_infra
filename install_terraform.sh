#!/bin/bash

VERSION=1.3.2
ARCH=`uname -m`

case "$ARCH" in
    arm*) EXT="arm" ;;
    *)    EXT="amd64" ;;
esac

case "$OSTYPE" in
    darwin*) FILENAME="darwin_$EXT" ;;
    *)       FILENAME="linux_$EXT" ;;
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
