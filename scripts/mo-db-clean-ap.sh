#!/bin/bash

SCR_DR="${BASH_SOURCE%/*}"
if [[ ! -d "$SCR_DR" ]]; then SCR_DR="$PWD"; fi

. "$SCR_DR/mo-db-fn-ap.sh"


mo-db-clean $1
mo-db-collections $1
