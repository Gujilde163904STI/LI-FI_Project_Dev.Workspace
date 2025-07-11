# crypto Module
| Since  | Origin / Contributor  | Maintainer  | Source  |
| :----- | :-------------------- | :---------- | :------ |
| 2015-06-02 | [DiUS](https://github.com/DiUS), [Johny Mattsson](https://github.com/jmattsson) | [Johny Mattsson](https://github.com/jmattsson) | [crypto.c](../../app/modules/crypto.c)|

The crypto modules provides various functions for working with cryptographic algorithms.

The following encryption/decryption algorithms/modes are supported:
- `"AES-ECB"` for 128-bit AES in ECB mode (NOT recommended)
- `"AES-CBC"` for 128-bit AES in CBC mode

The following hash algorithms are supported:
- MD5
- SHA1
- SHA256, SHA384, SHA512 (unless disabled in `app/include/user_config.h`)

## crypto.encrypt()

Encrypts Lua strings.

#### Syntax
`crypto.encrypt(algo, key, plain [, iv])`

#### Parameters
  - `algo` the name of a supported encryption algorithm to use
  - `key` the encryption key as a string; for AES encryption this *MUST* be 16 bytes long
  - `plain` the string to encrypt; it will be automatically zero-padded to a 16-byte boundary if necessary
  - `iv` the initilization vector, if using AES-CBC; defaults to all-zero if not given

#### Returns
The encrypted data as a binary string. For AES this is always a multiple of 16 bytes in length.

#### Example
```lua
print(encoder.toHex(crypto.encrypt("AES-ECB", "1234567890abcdef", "Hi, I'm secret!")))
```

#### See also
  - [`crypto.decrypt()`](#cryptodecrypt)


## crypto.decrypt()

Decrypts previously encrypted data.

#### Syntax
`crypto.decrypt(algo, key, cipher [, iv])`

#### Parameters
  - `algo` the name of a supported encryption algorithm to use
  - `key` the encryption key as a string; for AES encryption this *MUST* be 16 bytes long
  - `cipher` the cipher text to decrypt (as obtained from `crypto.encrypt()`)
  - `iv` the initialization vector, if using AES-CBC; defaults to all-zero if not given

#### Returns
The decrypted string.

Note that the decrypted string may contain extra zero-bytes of padding at the end. One way of stripping such padding is to use `:match("(.-)%z*$")` on the decrypted string. Additional care needs to be taken if working on binary data, in which case the real length likely needs to be encoded with the data, and at which point `:sub(1, n)` can be used to strip the padding.

#### Example
```lua
key = "1234567890abcdef"
cipher = crypto.encrypt("AES-ECB", key, "Hi, I'm secret!")
print(encoder.toHex(cipher))
print(crypto.decrypt("AES-ECB", key, cipher))
```

#### See also
  - [`crypto.encrypt()`](#cryptoencrypt)


## crypto.fhash()

Compute a cryptographic hash of a a file.

#### Syntax
`hash = crypto.fhash(algo, filename)`

#### Parameters
- `algo` the hash algorithm to use, case insensitive string
- `filename` the path to the file to hash

#### Returns
A binary string containing the message digest. To obtain the textual version (ASCII hex characters), please use [`encoder.toHex()`](encoder.md#encodertohex ).

#### Example
```lua
print(encoder.toHex(crypto.fhash("sha1","myfile.lua")))
```

## crypto.hash()

Compute a cryptographic hash of a Lua string.

#### Syntax
`hash = crypto.hash(algo, str)`

#### Parameters
`algo` the hash algorithm to use, case insensitive string
`str` string to hash contents of

#### Returns
A binary string containing the message digest. To obtain the textual version (ASCII hex characters), please use [`encoder.toHex()`](encoder.md#encodertohex).

#### Example
```lua
print(encoder.toHex(crypto.hash("sha1","abc")))
```

## crypto.new_hash()

Create a digest/hash object that can have any number of strings added to it. Object has `update` and `finalize` functions.

#### Syntax
`hashobj = crypto.new_hash(algo)`

#### Parameters
`algo` the hash algorithm to use, case insensitive string

#### Returns
Userdata object with `update` and `finalize` functions available.

#### Example
```lua
hashobj = crypto.new_hash("SHA1")
hashobj:update("FirstString")
hashobj:update("SecondString")
digest = hashobj:finalize()
print(encoder.toHex(digest))
```

## crypto.hmac()

Compute a [HMAC](https://en.wikipedia.org/wiki/Hash-based*message*authentication_code) (Hashed Message Authentication Code) signature for a Lua string.

#### Syntax
`signature = crypto.hmac(algo, str, key)`

#### Parameters
- `algo` hash algorithm to use, case insensitive string
- `str` data to calculate the hash for
- `key` key to use for signing, may be a binary string

#### Returns
A binary string containing the HMAC signature. Use [`encoder.toHex()`](encoder.md#encodertohex) to obtain the textual version.

#### Example
```lua
print(encoder.toHex(crypto.hmac("sha1","abc","mysecret")))
```

## crypto.new_hmac()

Create a hmac object that can have any number of strings added to it. Object has `update` and `finalize` functions.

#### Syntax
`hmacobj = crypto.new_hmac(algo, key)`

#### Parameters
- `algo` the hash algorithm to use, case insensitive string
- `key` the key to use (may be a binary string)

#### Returns
Userdata object with `update` and `finalize` functions available.

#### Example
```lua
hmacobj = crypto.new_hmac("SHA1", "s3kr3t")
hmacobj:update("FirstString")
hmacobj:update("SecondString")
digest = hmacobj:finalize()
print(encoder.toHex(digest))
```


## crypto.mask()

Applies an XOR mask to a Lua string. Note that this is not a proper cryptographic mechanism, but some protocols may use it nevertheless.

#### Syntax
`crypto.mask(message, mask)`

#### Parameters
- `message` message to mask
- `mask` the mask to apply, repeated if shorter than the message

#### Returns
The masked message, as a binary string. Use [`encoder.toHex()`](encoder.md#encodertohex) to get a textual representation of it.

#### Example
```lua
print(encoder.toHex(crypto.mask("some message to obscure","X0Y7")))
```
