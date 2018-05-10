#!/usr/bin/env bash

private_file="private.pem"
public_file="public.pem"
rm -f $private_file $public_file

read -p "Path to id_rsa? " id_rsa_path

cp $id_rsa_path $private_file
openssl rsa -in $id_rsa_path -pubout -out $public_file
