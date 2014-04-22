#!/bin/bash
#
# Watch for JS or CSS changes in the requested module.
##

# read in module and check if it's set
module=${1:-""}

# check if watchify is installed
hash watchify &> /dev/null
if [ $? -eq 1 ]; then
    echo "watchify not found! please npm install -g watchify";
    exit 0
fi

# set up paths
rootpath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
basepath="$rootpath/../../app/base";
modulepath="$rootpath/../../app/modules";
buildpath="$rootpath/../../build/public";

# read in environment config
. $rootpath/../defaults
. $rootpath/../config

### @TODO
### read in the command/options for the watchify base
### and modules, handle minification

# create buildpath if it doesn't exist
mkdir -p $buildpath/js
mkdir -p $buildpath/css

# if base was requested just write that out
if [ $module == "base" ] ; then
    watchify --debug -o $buildpath/js/base.js
else
    watchify --debug -e $modulepath/$module/index.js -o $buildpath/js/$module.js
fi