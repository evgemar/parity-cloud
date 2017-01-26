#!/bin/bash

# First init
if [ ! -f password.txt ]; then
  choose() { echo ${1:RANDOM%${#1}:1} $RANDOM; }
  echo "$({ choose '!@#$%^\&'
    choose '0123456789'
    choose 'abcdefghijklmnopqrstuvwxyz'
    choose 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    for i in $( seq 1 $(( 4 + RANDOM % 8 )) )
    do
      choose '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    done
    } | sort -R | awk '{printf "%s",$1}')" > /root/.parity/keys/password.txt
  parity account new --password /root/.parity/keys/password.txt 2>&1 | awk '{print $4}' > /root/.parity/keys/address.txt
fi

ADDRESS="$(cat /root/.parity/keys/address.txt)"
CHAIN="${CHAIN:-ropsten}"
echo -e "Start with:\n\taddress: 0x${ADDRESS}\n\tchain: ${CHAIN}"

exec parity --warp  \
            --no-ui  \
            --no-ipc  \
            --no-dapps \
            --jsonrpc-interface '0.0.0.0' \
            --jsonrpc-hosts='all' \
            --unlock 0x$ADDRESS    \
            --password /root/.parity/keys/password.txt \
            --chain=$CHAIN $@
