#!/bin/bash

S_NAME=$1 
S_PASS=$2
D_NAME=$3
D_PASS=$4

#SOURCE=$(aptible db:tunnel $S_NAME --port 12345) &
#echo Source process ID: $SOURCE
#sleep 10

#DESTIN=$(aptible db:tunnel $D_NAME --port 12346) &
#echo Destination process ID $DESTIN
#sleep 10

#$SOURCE=$(aptible db:tunnel $S_NAME --port 12345 &)
#$DESTIN=$(aptible db:tunnel $D_NAME --port 12346 &)


aptible db:tunnel $D_NAME --port 12346 &
DESTIN=$!
echo Destination process ID $DESTIN
sleep 20
aptible db:tunnel $S_NAME --port 12345 &
SOURCE=$!
echo Source process ID: $SOURCE
sleep 20



/usr/bin/mysql -v \
    --host=127.0.0.1 \
    --port=12346 \
    --user=aptible-nossl \
    --password=$D_PASS \
    db < my-db-clean.sql

/usr/bin/mysqldump -vv \
    --host=127.0.0.1 \
    --port=12345 \
    --user=aptible-nossl \
    --password=$S_PASS \
    --quick --routines --add-locks --add-drop-table --events  db | \
/usr/bin/mysql -v \
    --host=127.0.0.1 \
    --port=12346 \
    --user=aptible-nossl \
    --password=$D_PASS \
    db


kill $SOURCE $DESTIN
