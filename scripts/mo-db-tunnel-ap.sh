#!/bin/bash

D_NAME=$1

aptible db:tunnel $D_NAME --port 12346 &
DESTIN=$!
echo Destination process ID $DESTIN
echo $DESTIN > /tmp/mongo-tunnel-12346-pid
sleep 20