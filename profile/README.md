# Tillitis

Hello! This is [Tillitis AB's](https://tillitis.se/) Github presence.
Tillitis is the maker of the TKey, a new kind of USB security device.

- [Web shop](https://shop.tillitis.se/).
- [Developer Handbook](https://dev.tillitis.se).

## Current Work in Progress

We currently work on [FIDO2](https://github.com/tillitis/tkey-fido2).

FIDO2 runs only on Castor platform, currently in alpha release and
there is a tagged [version currently on
audit](https://github.com/tillitis/tillitis-key1/releases/tag/audit-2).

### About repositories, branches and releases

Main branches in all repositories are in development. We _aim_ to keep
main branches buildable and workning at all times, but it's not
guaranteed and there are some things to keep in mind:

- Main branches can be incompatible between repositories.
- To ensure compatibility between repositories use tagged releases,
  where compatibility is noted.
- Main branch can be used for e.g. early testing of new features.

## Team & keys

The core team is made up of:

- [Daniel Jobson](https://github.com/dehanj) |
  [PGP key](../keys/dehanj.asc)
- [Jonas Thörnblad](https://github.com/jthornblad) |
  [PGP key](../keys/jthornblad.asc)
- [Michael Cardell Widerkrantz](https://github.com/mchack-work) |
  [PGP key](../keys/mchack-work.asc)
- [Mikael Ågren](https://github.com/agren) |
  [PGP key](../keys/agren.asc)
- [Sasko Simonovski](https://github.com/SallSim) |
  [PGP key](../keys/SallSim.asc)

From 2025-09-17 we sign our Git tags with our SSH keys, which of
course is on our TKeys. We no longer sign individual commits. To
verify the tag signatures you need our
[allowed_signers](../keys/allowed_signers) file. Use like this:

```
git -c gpg.ssh.allowedSignersFile=/path/to/allowed_signers verify-tag v0.0.1
```

Or copy the file to the repo you are working in.

### Transition from PGP

On 2025-09-17 we stopped using PGP for Git. To ensure trust in the new
SSH keys in [allowed_signers](../keys/allowed_signers) one of us will
sign this file with PGP every time it changes during a transition
time, until we start signing it with a Tillitis vendor key.

You can verify that one of us has signed it by downloading:

- [allowed_signers](../keys/allowed_signers)
- [allowed_signers.sig](../keys/allowed_signers.sig)

and then run:

```
$ gpg --verify allowed_signers.sig
```

You are already assumed to have all our PGP keys (linked above).

To help trust the transition here are our SSH keys signed by our
former PGP keys (first part of e-mail address in `allowed_signers` in
parenthesis):

- [Michel Cardell Widerkrantz (mc)](../keys/mc-ssh.asc)
- [Daniel Jobson (jobson)](../keys/dj-ssh.asc)
- [Sasko Simonovski (sasko)](../keys/sallsim-ssh.asc)
- [Jonas Thörnblad (jonas)](../keys/jonas-ssh.asc)
- [Mikael Ågren (mikael)](../keys/agren-ssh.asc)

You can verify a PGP signature of one of our SSH key by running a
command like this:

```
$ gpg --verify mc-ssh.asc
gpg: Signature made Wed 17 Sep 2025 01:42:30 PM CEST
gpg:                using RSA key 52C45DA02B1AC8AC9565FB73D3DB3DDF57E704E5
gpg: Good signature from "Michael Cardell Widerkrantz <mc@tillitis.se>" [ultimate]
gpg:                 aka "Michael Cardell Widerkrantz (code signing) <mc@mullvad.net>" [ultimate]
Primary key fingerprint: 52C4 5DA0 2B1A C8AC 9565  FB73 D3DB 3DDF 57E7 04E5
```

Again, you are assumed to already have our PGP keys (linked to above).

### Former members

- [Björn Töpel](https://github.com/bjoto) |
  [PGP key](../keys/bjoto.asc)
- [Daniel Lublin](https://github.com/quite) |
  [PGP key](../keys/quite.asc)
- [Joachim Strömbergson](https://github.com/secworks) |
  [PGP key](../keys/secworks.asc)
- [Matthew Metts](https://github.com/cibomahto)
