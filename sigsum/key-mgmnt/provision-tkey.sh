#! /bin/bash

set -euo pipefail

# Require first argument
if [ $# -lt 1 ]; then
  echo "Usage: $0 <DEVICE NAME TO PROVISION> [age_encrypted_output_file]" >&2
  exit 1
fi

# Collect passed argument
device_name=$1
outfile=${2:-random.age}

recipients=./recipients

if [ -f "$outfile" ]; then 
  echo "Output file $outfile exists."
  exit 1
fi

# Random file names
tmprnd=$(mktemp /tmp/001.XXXXXXXXXXXXXXXXXXXXXX)
tmpb64=$(mktemp /tmp/010.XXXXXXXXXXXXXXXXXXXXXX)

# tkey-random-generator with signsture and verification
tkey-random-generator generate 32 -s -f $tmprnd
# Output for testing
# cat $tmprnd

# base64 encode
{ date -u; echo "Device Name: $device_name"; base64 < $tmprnd | tr -d '='; } > $tmpb64
# Remove random file
rm $tmprnd

# Output on terminal for checking decryption
echo "Content to encrypt"
echo "--------------"
cat $tmpb64
echo "--------------"

# Encrypt with age
age --encrypt -a -R $recipients < $tmpb64 > $outfile

# Remove base64 file
rm $tmpb64
echo "Encrypted age file written to: $outfile"
echo "Follow procedure on where and how to store it."

# Debug output
# cat $outfile

exit 0
