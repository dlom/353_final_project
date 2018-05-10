#!/usr/bin/env bash

public_file="public.pem"
rm -f ./*.enc

read -p "File to encrypt? " plaintext
read -p "Output file? " ciphertext

openssl rsautl -encrypt -pubin -inkey $public_file < $plaintext > $ciphertext
