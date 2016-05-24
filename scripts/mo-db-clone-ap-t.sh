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

NOW_IS=`date +%Y.%m.%d_%H.%M.%S`
#TMP_DIR=/tmp/mongodb-backup-$NOW_IS
TMP_F=/tmp/mongodb-backup-$NOW_IS
echo $NOW_IS

mo-db-tunnel $S_NAME 12345; SOURCE=$T_PID; echo "Source process ID: " $SOURCE

/usr/bin/mongodump -v \
    --host 127.0.0.1  --port  12345 \
    --username aptible  --password $S_PASS \
    --gzip \
    --oplog \
    --db db \
    --archive $TMP_F
          
kill $SOURCE

mo-db-tunnel $D_NAME 12346; DESTIN=$T_PID; echo "Destination process ID: " $DESTIN

./mo-db-clean-ap.sh $D_PASS > /tmp/mongodb-clean-dest-db-$NOW_IS.log 
cat /tmp/mongodb-clean-dest-db-$NOW_IS.log

/usr/bin/mongorestore -v \
    --host 127.0.0.1 \
    --port 12346 \
    --ssl \
    --sslAllowInvalidHostnames \
    --sslAllowInvalidCertificates \
    --username aptible \
    --password $D_PASS \
    --gzip \
    --oplogReplay \
    --db db \
    --archive $TMP_F

mo-db-collections $D_PASS

kill $DESTIN

rm -f $TMP_F

