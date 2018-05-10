from OpenSSL import crypto

def read_file(file):
    with open(file, "rt") as input:
        return input.read()

def write_file(string, file):
    with open(file, "wt") as output:
        output.write(string)

def read_binary_file(file):
    with open(file, "rb") as input:
        return bytearray(input.read())

def write_binary_file(string, file):
    with open(file, "wb") as output:
        output.write(bytes(string))

def bytes2num(bytes):
    return int("".join("{:02x}".format(b) for b in bytes), 16)

def num2ascii(num):
    hexified = "{:x}".format(num)
    padded_hexified = hexified if len(hexified) % 2 == 0 else "0" + hexified
    return padded_hexified.decode("hex")

def pkcs1_unpad(text):
    if len(text) > 0 and text[0] == "\x02":
        pos = text.find("\x00")
        if pos > 0:
            return text[pos+1:]
    return None

def read_encrypted(file):
    raw = read_binary_file(file)
    return bytes2num(raw)

def read_private(file):
    contents = read_file(file)
    private_key = crypto.load_privatekey(crypto.FILETYPE_PEM, contents)
    rsa_key = private_key.to_cryptography_key()
    private_nums = rsa_key.private_numbers()
    public_nums = private_nums.public_numbers
    return dict(e=public_nums.e, n=public_nums.n, d=private_nums.d)

def read_public(file):
    contents = read_file(file)
    public_key = crypto.load_publickey(crypto.FILETYPE_PEM, contents)
    rsa_key = public_key.to_cryptography_key()
    public_nums = rsa_key.public_numbers()
    return dict(e=public_nums.e, n=public_nums.n)

def decrypt(private_key, cooked):
    priv = read_private(private_key)
    encrypted = read_encrypted(cooked)
    unencrypted = power_mod(encrypted, priv["d"], priv["n"])
    return pkcs1_unpad(num2ascii(unencrypted))

def load_sig(public_key, sig):
    pub = read_public(public_key)
    signature = read_encrypted(sig)
    out = power_mod(signature, pub["e"], pub["n"])
    return num2ascii(out)

def create_payload(public_key, ciphertext, to_sign):
    pub = read_public(public_key)
    n = pub["n"]
    e = pub["e"]

    r = randint(0, n - 1)
    c = read_encrypted(ciphertext)
    x = power_mod(r, e, n)
    y = (x * c) % n
    write_binary_file(num2ascii(y), to_sign)
    return r

def continue_with_payload(public_key, signed, r, plaintext):
    pub = read_public(public_key)
    n = pub["n"]

    t = inverse_mod(r, n)
    u = read_encrypted(signed)
    m = (t * u) % n
    ascii = num2ascii(m)
    write_file(pkcs1_unpad(ascii), plaintext)
