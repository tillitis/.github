# Provisioning TKey for Sigsum Operations

This document outlines the steps to provision a TKey for use as
signing-oracle in a Sigsum log or witness.

## Pre-requisites

- Air gapped provisioning machine, with following installed:
  - [Tkey Random Generator][]
  - [age][]
  - [age plugin TKey][]
  - [USS provisioning script](./provisioning-tkey-sh)

[Tkey Random Generator]: https://www.tillitis.se/applications/tkey-random-number-generator/
[age]: https://github.com/FiloSottile/age
[age plugin TKey]: https://github.com/quite/age-plugin-tkey

The following is also needed:

- 2 USB memories for storing encrypted USS
- Age recipient keys for all Tillitis Employees that are approved for
  working with provisioning of logs and witnesses
  - Age identity shall be generated with TKey by each employee

## Provisioning Process

### Produce TKey's

When producing TKey's follow the normal provisioning flow on the
provisioning machine, with following deviations in the process:

- Generate the UDS to be used, separately
- Note the UDS on paper and store paper in tamper-evident bag
- Provision signing-oracle and backup TKey with the same UDS
- Delete unencrypted file with UDS from the system

### Generate USS

- Make sure there is a file `recipients` in the same directory as the
  script and it contains all recipients age identities[^1]
- Generate USS by running the script:

```bash
./provisioning-tkey.sh <device name> [output file name]

<device name>       name of device, for identification
[output file name]  output file name, make sure it's unique. Default
file name: random.age
```

- Encrypted age file is created in the same directory where the script
  is located

### Finalize provisioning

- Copy the age file containing USS to two USB memories
- Put the USB memories in respective tamper-evident bag
- Note all tammper-evident bags serial numbers and update respective
[audit log](./audit-logs/)

[^1]: Age identity shall be generated with employees personal TKey
