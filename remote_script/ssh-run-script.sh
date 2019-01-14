#!/bin/bash

#SCRIPT="remote-inventory.sh"
SCRIPT="remote-hostname.sh"

HOSTS="hosts.txt"
ERRORLOG="error-log.txt"
LOG="log.txt"

echo > $LOG
echo > $ERRORLOG

## function executes with 2 arguments:
## 1st - $1 - Host, where you want to run your script
## 2st - $2 - name of script, that you want to run remotely
## If ssh connection wasn't success, then IP is written to error Log
function SSH {
  ssh $1 'bash -s' < $2 2>&1
  STAT="$?"
  if [[ $STAT -ne 0 ]]
    then
    echo "$1  error" >> $ERRORLOG
  fi
}

## main

for SN in `cat $HOSTS`
  do
  echo "-------------------------------------" | tee -a $LOG
  echo $SN | tee -a $LOG
  SSH $SN $SCRIPT | tee -a $LOG
  echo | tee -a $LOG
  done

echo " -----------done-----------" | tee -a $LOG
sleep 1

