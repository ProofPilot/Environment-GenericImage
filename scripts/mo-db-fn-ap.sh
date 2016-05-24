#!/bin/bash

mo-db-tunnel() {
    local DB_NAME=$1
    local DB_PORT=$2
    aptible db:tunnel $DB_NAME --port $DB_PORT &
    T_PID=$!
    sleep 30
}

mo-db-clean () {
    local D_PASS=$1
    /usr/bin/mongo  --host 127.0.0.1 --port 12346 \
      --ssl --sslAllowInvalidHostnames --sslAllowInvalidCertificates \
      --username aptible --password $D_PASS \
      --verbose \
      db mo-db-clean.js
}


mo-db-collections() {
local D_PASS=$1
cat <<EOF 


****************************************
  COLLECTIONS:
========================================
EOF

/usr/bin/mongo \
    --host 127.0.0.1 \
    --port 12346 \
    --ssl \
    --sslAllowInvalidHostnames \
    --sslAllowInvalidCertificates \
    --username aptible \
    --password $D_PASS \
    db \
    --eval "db.getCollectionNames();"
}