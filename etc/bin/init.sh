#!/bin/bash
#
# Set up the directories and the environment
##

# always the location of this script
rootpath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
apppath="$rootpath/../../app";
buildpath="$rootpath/../../build";

mkdir -p $apppath
mkdir -p $apppath/{base,modules}
mkdir -p $apppath/base/{images,lib,styles,views}
touch $apppath/base/styles/index.less
mkdir -p $buildpath/public
mkdir -p $buildpath/public/{css,fonts,img,js}

# set up module directories
modulefile="$rootpath/../modules"
IFS=$'\r\n' modules=($(cat $modulefile))

# read in environment config
. $rootpath/../config

for module in "${modules[@]}"
do
    mkdir -p $buildpath/$module
    mkdir -p $apppath/modules/$module
    mkdir -p $apppath/modules/$module/{controllers,images,lib,styles,views}
    touch $apppath/modules/$module/index.js
    touch $apppath/modules/$module/styles/index.less
done

if [ "$useHtaccess" == "yes" ] ; then
    cp $rootpath/../htaccess $buildpath/.htaccess
fi
