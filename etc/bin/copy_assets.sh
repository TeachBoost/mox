#!/bin/bash
#
# Copies fonts and images to the build folders
##

# set up paths
rootpath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
apppath="$rootpath/../../app";
vendorpath="$rootpath/../../vendor";
buildpath="$rootpath/../../build";

# read module names from ./modules and put them into an array
modulefile="$rootpath/../modules"
IFS=$'\r\n' modules=($(cat $modulefile))

# create buildpath if it doesn't exist
mkdir -p $buildpath/public/img
mkdir -p $buildpath/public/fonts

# copy over base assets
if [ "$(ls -A ${apppath}/base/images)" ] ; then 
    cp -r $apppath/base/images/* $buildpath/public/img/
fi

# copy over module assets
for module in "${modules[@]}"
do
    if [[ -d "$apppath/modules/$module/images" && "$(ls -A $apppath/modules/$module/images)" ]] ; then
        cp -r $apppath/modules/$module/images/* $buildpath/public/img/
    fi
done

###
### Add commands to copy files from your vendor path
### to your public directories. This is where you would
### copy your bootstrap fonts, fontawesome fonts, vendor
### images and assets.
###
