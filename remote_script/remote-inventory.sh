#!/bin/bash

echo " $HOSTNAME"
declare -a IP
IP=( `ip a | grep -oE "((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])" | grep -v "127.0.0.1" | grep -v "0.0.0.0" | sort -n | uniq` )

declare -a DIRS
###--ping directory names
#DIR=( `ls -1 /var/www/` )
###--ping ServerNames
DIR=( `find /etc/httpd/conf.d/ -name "*.conf" | grep -v "php.conf" | grep -v "autoindex.conf" | grep -v "welcome.conf" | grep -v "userdir.conf" | xargs cat | grep -i "servername" |  tr -d "#" | sed "s/^[ \t]*//" | sed "s/^[^ ]*\(.*\)$/\1/"| tr -d " " | sort -u | uniq` )

ENDDIR=${#DIR[@]}
ENDIP=${#IP[@]}

for (( ADIR = 0; ADIR < $ENDDIR; ADIR++ ))
  do
  PING=$( ping -w 1 ${DIR[$ADIR]} 2>/dev/null )

  for (( AIP = 0; AIP < $ENDIP; AIP++ ))
    do
    WC=$( echo "$PING" | grep -w ${IP[$AIP]} | wc -m )
    if [ $WC -ne 0 ]
      then
      echo "${DIR[$ADIR]} ${IP[$AIP]}"
    fi
  done
done


