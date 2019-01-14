#!/bin/bash

declare -a CAT
CAT=( `cat hosts.txt` )
END=${#CAT[@]}
X=1 ##SiteName
Y=0 ##IP
declare -a PING

## logging
LOK="ok.txt"
LER="error.txt"
echo > $LOK
echo > $LER

while [ $Y -lt $END ]
  do
  PING=$( ping -w 1 ${CAT[$X]} 2>&1)
  WC=$( echo "$PING" | grep ${CAT[$Y]} | wc -m )

  if [ $WC -eq 0 ]
    then
    echo | tee -a $LER
    echo "--------------------------------------------" | tee -a $LER
    echo "#####  WRONG IP #####" | tee -a $LER
    echo "${CAT[$X]}  ${CAT[$Y]}" | tee -a $LER
    echo "$PING" | tee -a $LER
    echo
  else
    echo "${CAT[$X]}  ${CAT[$Y]}  DNS OK" | tee -a $LOK
  fi

  X=$[ $X + 2 ]
  Y=$[ $Y + 2 ]
done

echo "--------DONE----------" | tee -a $LER
echo "--------DONE----------" >> $LOK
sleep 1
