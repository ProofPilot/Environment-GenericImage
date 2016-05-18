#!/bin/bash

D_PASS=$1


aptible db:tunnel $D_NAME --port 12346 &
DESTIN=$!
echo Destination process ID $DESTIN
sleep 30


/usr/bin/mongo \
    --host 127.0.0.1 \
    --port 12346 \
    --ssl \
    --sslAllowInvalidHostnames \
    --sslAllowInvalidCertificates \
    --username aptible \
    --password $D_PASS \
    db
