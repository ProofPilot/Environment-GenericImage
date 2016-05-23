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

NOW_IS=`%Y.%m.%d_%H.%M.%S`
TMP_DIR=/tmp/mongodb-backup-$NOW_IS
echo $TMP_DIR


aptible db:tunnel $S_NAME --port 12345 &
SOURCE=$!
echo Source process ID: $SOURCE
sleep 20

/usr/bin/mongodump \
    --host 127.0.0.1 \
    --port 12345 \
    --username aptible \
    --password $S_PASS \
    --db db \
    --gzip \
    --oplog \
    --out $TMP_DIR
          
kill $SOURCE

aptible db:tunnel $D_NAME --port 12346 &
DESTIN=$!
echo Destination process ID $DESTIN
sleep 20

./mo-db-clean-ap.sh $D_PASS > /tmp/mongodb-clean-dest-db-$NOW_IS.log

/usr/bin/mongorestore \
    --host 127.0.0.1 \
    --port 12346 \
    --ssl \
    --sslAllowInvalidHostnames \
    --sslAllowInvalidCertificates \
    --username aptible \
    --password $D_PASS \
    --db db \
    --oplogReplay \
    $TMP_DIR/db


kill $DESTIN

rm -rf $TMP_DIR

