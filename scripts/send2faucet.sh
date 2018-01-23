#!/bin/bash
if [ -z $1 ];
then
    echo "must include signedtx";
    exit;
fi
signedtx=$1
senttx=$(bitcoin-cli -named sendrawtransaction hexstring=$signedtx)

