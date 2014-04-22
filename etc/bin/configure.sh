#!/bin/bash
#
# Copies environment file to etc/config
##

env=${1:-"development"}
rootpath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

if [ ! -f "$rootpath/../env/$env" ]; then
    echo "Environment file '$env' not found!";
    exit 0
fi

cp $rootpath/../env/$env $rootpath/../config
