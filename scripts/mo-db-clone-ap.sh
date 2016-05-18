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

TMP_DIR=/tmp/`date +mongodb-backup-%Y.%m.%d_%H.%M.%S`
echo $TMP_DIR


aptible db:tunnel $S_NAME --port 12345 &
SOURCE=$!
echo Source process ID: $SOURCE
sleep 20

/usr/bin/mongodump -v \
    --host 127.0.0.1 \
    --port 12345 \
    --username aptible \
    --password $S_PASS \
    --db db \
    --out $TMP_DIR
          
kill $SOURCE

aptible db:tunnel $D_NAME --port 12346 &
DESTIN=$!
echo Destination process ID $DESTIN
sleep 20

./mo-db-clean.sh $D_PASS

/usr/bin/mongorestore \
    --host 127.0.0.1 \
    --port 12346 \
    --ssl \
    --sslAllowInvalidHostnames \
    --sslAllowInvalidCertificates \
    --username aptible \
    --password $D_PASS \
    --db db \
    $TMP_DIR/db


kill $DESTIN

rm -rf $TMP_DIR

