#!/bin/bash
#
# Compiles the app/base/template.html to the respective
# build/<module>/index.html file.
##

# always the location of this script
rootpath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
template="$rootpath/../template.shtml";

# read in environment config
. $rootpath/../defaults
. $rootpath/../config

for module in "${modules[@]}"
do
    mkdir -p $rootpath/../../app/modules/$module
    title='';
    outputFile="$rootpath/../../build/$module/index.html";
    echo "Writing app/modules/$module/index.html"

    # set up asset version path if enabled
    versionPath="public";
    if [[ "$useAssetVersion" == "yes" ]] ; then
        assetVersionFile="$rootpath/../../asset_version";
        versionPath=$(cat $assetVersionFile);
    fi

    # check if there's a module template
    if [ -f "$rootpath/../../app/modules/$module/index.shtml" ]; then
        . $rootpath/../../app/modules/$module/index.shtml
    else
        . $template
    fi
done