#!/bin/bash
if [ -z $1 ];
then
    echo "must include recipient";
    exit;
fi
recipient=$1
change_addr=$(bitcoin-cli getrawchangeaddress)
utxo_txid=$(bitcoin-cli listunspent | jq -r '.[0] | .txid') 
utxo_vout=$(bitcoin-cli listunspent | jq -r '.[0] | .vout')
total_amount=$(bitcoin-cli listunspent | jq -r '.[0] | .amount')
amount_to_pay=$(echo "x=$total_amount  - 0.001; if(x < 1) print 0;x" | /usr/bin/bc -l) 
rawtxhex=$(bitcoin-cli -named createrawtransaction inputs='''[ { "txid": "'$utxo_txid'", "vout": '$utxo_vout' }]''' outputs='''{ "'$recipient'": "'$amount_to_pay'" }''')
signedtx=$(bitcoin-cli -named signrawtransaction hexstring=$rawtxhex | jq -r '.hex')
echo "$signedtx"


