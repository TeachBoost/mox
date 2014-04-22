#!/bin/bash
#
# Build the JS and CSS for the requested module, or the base
# assets if base is specified.
##

hash browserify &> /dev/null
if [ $? -eq 1 ]; then
    echo "browserify not found! please npm install -g browserify";
    exit 0
fi

hash lessc &> /dev/null
if [ $? -eq 1 ]; then
    echo "less not found! please npm install -g less";
    exit 0
fi

# get flags
debug=""
minify=0
while getopts ":dm" opt; do
    case $opt in
        d)
            debug="--debug"
            ;;
        m)
            minify=1
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

# read in module
module=${1:-"base"}

# set up paths
rootpath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
basepath="$rootpath/../../app/base";
modulepath="$rootpath/../../app/modules";
buildpath="$rootpath/../../build/public";
vendorpath="$rootpath/../../vendor";

# read module names from ./modules and put them into an array
modulefile="$rootpath/../modules"
IFS=$'\r\n' modules=($(cat $modulefile))

### @TODO
### read in the command/options for the browserify base
### and modules, handle minification

# read in environment config
. $rootpath/../config

# create buildpath if it doesn't exist
mkdir -p $buildpath/js
mkdir -p $buildpath/css

# if base was requested just write that out
if [ $module == "base" ] ; then
    # write the base javascript
    if [[ $minify == 0 ]] ; then
        browserify $debug -o $buildpath/js/base.js
    else
        browserify $debug -o $buildpath/js/base.js
    fi

    ### @TODO
    ### 1. copy over any vendor files specified in the config
    ### 2. cat any css files (in order) specified in the config
    ###    into the base.css

    # less compile the less files
    lessc $basepath/styles/index.less >> $buildpath/css/base.css
elif [ $module == "all" ] ; then
    baseModule=( 'base' )
    buildModules=("${baseModule[@]}" "${modules[@]}")
else
    buildModules=( $module );
fi

# iterate through modules and write them out
for mod in "${buildModules[@]}"
do
    # write the module javascript bundle
    browserify $debug -e $modulepath/$mod/index.js -o $buildpath/js/$mod.js

    # write the module CSS
    if [[ -d "$modulepath/$mod/styles" && -f "$modulepath/$mod/styles/index.less" ]] ; then
        lessc $modulepath/$mod/styles/index.less > $buildpath/css/$mod.css
    fi
done