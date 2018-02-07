#!/bin/bash
if [[ $# -ne 2 ]];
then
    echo "must include recipient and index";
    exit;
fi
recipient=$1
change_addr=$(bitcoin-cli getrawchangeaddress)
utxo_txida=($(bitcoin-cli listunspent | jq -r '.[] | .txid')) 
total_amounta=($(bitcoin-cli listunspent | jq -r '.[] | .amount'))
utxo_vouta=($(bitcoin-cli listunspent | jq -r '.[] | .vout'))

utxo_txid=
total_amount=
utxo_vout=
#for ((i=0; i < ${#utxo_txida[*]}; ++i)); do
#	echo "${utxo_txida[i]}"
#done

len=${#utxo_txida[*]}
#echo $len
if (( $2 < $len )); then
	utxo_txid=${utxo_txida[$2]}	
	total_amount=${total_amounta[$2]}
	utxo_vout=${utxo_vouta[$2]}
fi
#echo "$utxo_txid"
#echo "$utxo_vout"
#echo "$total_amount"


amount_to_pay=$(echo "x=$total_amount / 2.0; if(x < 1) print 0;x" | /usr/bin/bc -l)
amount_to_return=$(echo "x=$amount_to_pay -2 * 0.001;if (x <1) print 0;x" | /usr/bin/bc)
rawtxhex=$(bitcoin-cli -named createrawtransaction inputs='''[ { "txid": "'$utxo_txid'", "vout": '$utxo_vout' }]''' outputs='''{ "'$recipient'": "'$amount_to_pay'", "'$change_addr'": "'$amount_to_return'" }''')
signedtx=$(bitcoin-cli -named signrawtransaction hexstring=$rawtxhex | jq -r '.hex')
echo "$signedtx"

