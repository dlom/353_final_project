#!/usr/bin/env bash

private_file="private.pem"
public_file="public.pem"
rm -f $private_file $public_file

read -p "How many bits? " bits
read -p "Passphrase? " passphrase
if [ ${#passphrase} -le 3 ]; then
    echo "Passphrase needs to be at least 4 characters long"
    exit 1
fi

openssl genrsa -aes128 -passout pass:$passphrase -out $private_file $bits
openssl rsa -in $private_file -passin pass:$passphrase -pubout -out $public_file
