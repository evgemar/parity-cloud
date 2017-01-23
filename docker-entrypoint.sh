#!/bin/bash

CHAIN="${CHAIN:-ropsten}"

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
    } | sort -R | awk '{printf "%s",$1}')" > password.txt
  parity --chain=$CHAIN account new --password password.txt 2>&1 > address.txt 
fi

ADDRESS="$(cat address.txt)"
echo -e "Start with:\n\taddress: 0x${ADDRESS}\n\tchain: ${CHAIN}"

exec parity --warp \
            --no-ipc \
            --no-dapps \
            --jsonrpc-interface '0.0.0.0' \
            --jsonrpc-hosts='all' \
            --unlock $ADDRESS \
            --password password.txt \
            --chain=$CHAIN $@
