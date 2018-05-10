#!/usr/bin/env bash

private_file="private.pem"
rm -f ./*.sig

read -p "File to sign? " to_sign
read -p "Passphrase? " passphrase

openssl rsautl -sign -raw -inkey $private_file -passin pass:$passphrase -in $to_sign -out $to_sign.sig
