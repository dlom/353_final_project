CPSC 353 Final Project
======================

Blind signature attack on RSA

* `genkeys.sh`: generates an RSA key pair in the [pem](https://en.wikipedia.org/wiki/Privacy-enhanced_Electronic_Mail) format
* `convertkeys.sh`: convert an existing ssh RSA key into the pem format. `id_rsa` is probably stored at `~/.ssh/id_rsa`
* `encrypt.sh`: encrypt a file using RSA with the public key
* `sign.sh`: sign a file using RSA with the private key
* `final.sage`: contains several functions for dealing with RSA key pairs, as well as the actual code for the attack

## `final.sage`

Only two functions are actually necessary to perform the attack:

* `create_payload(public_key: Path, ciphertext: Path, to_sign: Path): number`
* `continue_with_payload(public_key: Path, signed: Path, r: number, plaintext: Path): void`

## Usage (in a trivial case)

1. Generate a key pair with `./genkeys.sh` (or convert an existing ssh key)
2. Create a plaintext file and encrypt it with `./encrypt.sh`
3. Use sage to run `r = create_payload("public.pem", "encrypted.bin", "to_sign")` (substitute your encrypted file's path)
4. Sign the file `to_sign` with `./sign.sh`
5. Use sage to run `continue_with_payload("public.pem", "to_sign.sig", r, "deciphered.txt")`
6. Inspect the contents of the deciphered message and verify that it matches with the original plaintext
