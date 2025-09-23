# Key management

This document provides a key management strategy using Tillitis
[Tkey][]. it's intended use it to manage private Ed25519 keys for
[Sigsum][] log servers and witnesses.

[Tkey]: https://www.tillitis.se/products/tkey/
[Sigsum]: https://www.sigsum.org

## Introduction

An introduction on Tillitis TKey inner workings can be found in this
[blog post][] and more detailed information can be found in the
[Tillitis TKey repository][] on GitHub. TKey [threat model] can be
good to also read.

It is also good to read up on how to install and setup [Tkey SSH
Agent][]. More details can be found in the
[tkey-ssh-agent-repository][].

Also, [TKey Random Number Genrator][] will be used to generate random
passphrases.

[Age][] together with each employees personal TKey is used for
encrypting passphrases (USS).

[blog post]: https://www.tillitis.se/blog/2023/03/31/on-tkey-key-generation/
[Tillitis TKey repository]: https://github.com/tillitis/tillitis-key1
[Tkey SSH Agent]: https://www.tillitis.se/applications/tkey-ssh-agent/
[tkey-ssh-agent-repository]: https://github.com/tillitis/tkey-ssh-agent/
[TKey Random Number Genrator]: https://www.tillitis.se/applications/tkey-random-number-generator/
[Age]: https://github.com/FiloSottile/age
[threat model]: https://github.com/tillitis/tillitis-key1/blob/main/doc/threat_model/threat_model.md

## Overview

The overall objectives are:

1. Signing requires access to a localhost-only TKey and a 128-bit
   secret generated while the device was started. This _signing-oracle
TKey_ is plugged into a networked node at all times (i.e., a primary
log server, a secondary log server, or a witness), and is only usable
as a signing oracle if an authentication passphrase (USS) is made
available.
2. Re-provisioning requires access to a _backup TKey_ (that is
   identical to _signing-oracle_ TKey as it contains the same UDS) and
the passphrase (USS).
3. UDS for a _signing-oracle_ TKey and its backup TKey is identical.
   As a last resort backup the UDS is also stored separately. This
makes it possible to manufacture a new identical TKey should the
_signing-oracle_ and backup TKey for some reason be damaged.
4. A single trusted operator can gain access to all TKeys, UDS and the
   secret passphrase needed to make use of them.
5. Secret passphrases (USS) and UDS are stored encrypted (with age)
   and can only be decrypted by employees with their personal TKey.
Each USS and UDS is stored in its separate file.

These objectives imply a threat model where trusted operators are
honest at all times.  In other words, what we are trying to protect
against are external threats and failures.  Examples of threats
include a device that gets physically stolen or remotely accessible as
a result of a networked node being owned. Examples of failures include
devices that break. We assume that one out of two devices function at
all times.

[Randomness produced by a TKey][] is assumed to be good, so that the
generated passphrase is computationally hard to brute force (128-bit
security).

For key recovery, the attacker needs to gain access to a backup TKey
and its secret passphrase (USS). This is assumed to be hard: one
physical security boundary, one cryptographic boundary and hacking
TKey need to be breached at the same time for the attacker to succeed.

For signing-oracle access, a (local) attacker can steal a node's TKey
and breach another physical security perimeter and one cryptographic
boundary to gain access to its passphrase (USS). This, too, is assumed
to be hard.

For signing-oracle access, a (remote) attacker may gain root access on
an active node. This may be the most likely attack scenario.  It is
also hard to detect if no physical boundary is breached.

For creating a copy of TKey, the attacker needs to breach two
cryptographic security boundaries to obtain UDS and USS. This is
assumed to be hard.

Note how log servers have a larger (remote) attack surface than
witnesses, simply because witnesses can be operated from less public
vantage points.

For physical security and detection of breaches we rely on locks,
alarms, safes, tamper-evident bags, etc.  Detection of a breach is
generally assumed to be rapid and obvious; but as a defense-in-depth
we also do a few routine checks.

[Randomness produced by a TKey]: https://www.tillitis.se/blog/2024/05/27/high-quality-noise-in-a-fpga-how-the-tkey-trng-works/

## Description

### Unique Device Secret (UDS)

Unique Device Secret (UDS) is the base secret in TKey. Each
_signing-oracle_ and its corresponding backup TKey has the same UDS.
To be able to create more backup TKey's due to damage or other
malfunction UDS is also stored in an age encrypted file, with
recipients set to all employees at Tillitis.

UDS is a 256-bit random number generated with `TKey Random Generator`.

Encrypted file is stored in repo FIXME.

### Secret passphrase (USS)

Secret passphrase (USS) is used by TKey in the key derivation
function. The passphrase is 32 bytes, generated by using the `TKey
Random Generator` and then base64 encoded. `TKey Random Generator`
can be run on the same TKey used as _signing-oracle_.

Secret passphrase is stored in an age encrypted file, with
recipients set to all employees at Tillitis. Employees shall use their
TKeys to decrypt the file. File is stored in repo FIXME.

(Reasoning: An alternative could be to store the USS in clear text,
written down on a piece of paper, stored in an tamper-evident bag,
which in turn is stored in a safe. Problem is that if USS is leaked,
it implies that USS needs to be changed and this in turn means that we
effectively operate a new witness.)

### Backup TKey

We have one backup TKey that is a complete replicate of the
_signing-oracle_ TKey.

Store backup TKey in tamper-evident bag on a secure location.
Use the same procedure to track locations and serial numbers as for
USB thumb drives.

If it is detected that a backup TKey is breached (e.g., it is lost or
somehow broken), reprovision so that there is a new backup TKey.

Below is an example of a table that could be tracked in a git repository.  E.g.,
before opening a tamper-evident bag and subsequently replacing it, one would
confirm with the others that they currently have and still get the same table.

| Date       | Storage location | Device | Bag serial number | Notes                    |
|------------|------------------|--------|-------------------|--------------------------|
| YYYY-MM-DD | Location A       | TKey1  | 00 000 000 001    | Initial provisioning     |
| YYYY-MM-DD | Location A       | TKey1  | 00 000 000 002    | Q4-25 check Ok.          |

**Routine:** check that the backup TKey works every three months.

### Signing oracle TKey

The signing-oracle TKey creates it keys(s) at startup when the device
app is loaded onto TKey and secret passphrase (USS) is provided at
request. Secret passphrase is manually written in the pin entry dialog
box. See [above](#secret-passphrase-uss) how passphrase is retrieved.

If it is detected that a signing-oracle TKey is breached (e.g., it is lost or
somehow broken) install the backup TKey and provision a new backup
TKey.

**Routine:** Automate checks that verify if a node's TKey is plugged-in.

## Getting started

### Equipment

- 1x backup TKey
- 1x signing-oracle TKey (witness)
- 1x dedicated provisioning machine configured with [TKey2 tooling][], the
  scripts for automation (see README instructions), and no network access
- 1x git repository
- Many tamper-evident bags

[TKey2 tooling]: https://github.com/Yubico/yubihsm-shell

### Locations

- 1x physically secure site for backup TKey and provisioning machine
- Secure site(s) where the machines with online TKeys are operated

The sites that contain backup and signing-oracle TKeys may be the
same, but should in that case have different security boundaries.

### Provisioning

Provisioning shall be done on a provisioning machine that is not
connected to any network.

Take TKeys from ordinary production flow, before provisioning step. On
provisioning machine generate random UDS and provision one
_signing-oracle_ and one backup TKey with this UDS. Store UDS in an
age encrypted file, with recipients set to all employees at Tillitis.
Follow normal procedure to erase UDS from provisioning machine.

FIXME
Run [USS provision script](../../README.md) for generating USS and
follow the instructions. Take note of which TKey serial number is
provisioned with what. Save `random.age` files on a USB memory.
Upload age files to repository FIXME.

Put backup TKeys into tamper-evident bags. Populate the git repository
table with initial storage locations and serial numbers.

Transport the different devices to their distinct storage locations.
Plug signing-oracle TKeys into their respective networked nodes, or
store them in the same physical location as a backup TKey until they
are ready to be used.

Appoint someone to be responsible for following up on routine checks.

If it is desired to showcase to others that this provision ceremony
was used, optionally invite one or more independent parties to witness
and take notes.
