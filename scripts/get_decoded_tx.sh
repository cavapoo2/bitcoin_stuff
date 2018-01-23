#!/bin/bash
if [ -z $1 ];
then
    echo "must include signedtx";
    exit;
fi
signedtx=$1
decoded=$(bitcoin-cli -named decoderawtransaction hexstring=$signedtx)
echo "$decoded"


