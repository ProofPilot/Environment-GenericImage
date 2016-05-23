#!/bin/bash 

# Rebuild ALL apps in environment passed through first parameter.
aptible apps --environment=$1 | grep -v -e === -e '^$' | \
  xargs -I {} aptible rebuild --app={}

