#!/bin/bash

D_PASS=$1


/usr/bin/mongo  --host 127.0.0.1 --port 12346 \
    --ssl --sslAllowInvalidHostnames --sslAllowInvalidCertificates \
    --username aptible --password $D_PASS \
    --verbose \
    db mo-db-clean.js

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

