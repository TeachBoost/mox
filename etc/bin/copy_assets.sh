#!/bin/bash
#
# Copies fonts and images to the build folders
##

# set up paths
rootpath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
apppath="$rootpath/../../app";
vendorpath="$rootpath/../../vendor";
buildpath="$rootpath/../../build";

# read in environment config
. $rootpath/../defaults
. $rootpath/../config

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

# copy over images
for imgDir in "${!buildBaseImg[@]}" ; do
    vendorDir="${buildBaseImg["$imgDir"]}"
    mkdir -p $buildpath/public/img/$imgDir
    cp $vendorpath/$vendorDir/* $buildpath/public/img/$imgDir/
done

# copy over fonts
for fontFile in "${buildBaseFont[@]}" ; do
    cp $vendorpath/$fontFile $buildpath/public/fonts/
done