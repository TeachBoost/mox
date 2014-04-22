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
minify=""
while getopts ":dm" opt; do
    case $opt in
        d)
            debug="--debug"
            ;;
        m)
            minify="-t [ uglifyify -x .js ]"
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

# read in environment config
. $rootpath/../defaults
. $rootpath/../config

# create buildpath if it doesn't exist
mkdir -p $buildpath/js
mkdir -p $buildpath/css

# if base was requested just write that out
if [[ $module == "base" || $module == "all" ]] ; then
    # write the base javascript
    buildModules=()
    out="-o $buildpath/js/base.js"
    cmd=( "browserify" "$debug" "${browserifyBase[@]}" "$minify" "$out" )
    eval ${cmd[@]}

    # copy any JS files
    for jsFile in "${!buildBaseJs[@]}" ; do
        buildFilename="${buildBaseJs["$jsFile"]}"
        cp $vendorpath/$jsFile $buildpath/$buildFilename
    done

    # prepend any css files
    echo -n "" > $buildpath/css/base.css
    for cssFile in "${buildBaseCss[@]}" ; do
        cat $vendorpath/$cssFile >> $buildpath/css/base.css
    done

    # less compile the less files
    lessc $basepath/styles/index.less >> $buildpath/css/base.css
else
    buildModules=( $module )
fi

if [ $module == "all" ] ; then
    buildModules=("${modules[@]}")
fi

# iterate through modules and write them out
for mod in "${buildModules[@]}"
do
    # write the module javascript bundle
    entry="-e $modulepath/$mod/index.js"
    out="-o $buildpath/js/$mod.js"
    cmd=( "browserify" "$debug" "$entry" "${browserifyModule[@]}" "$minify" "$out" )
    eval ${cmd[@]}

    # write the module CSS
    if [[ -d "$modulepath/$mod/styles" && -f "$modulepath/$mod/styles/index.less" ]] ; then
        lessc $modulepath/$mod/styles/index.less > $buildpath/css/$mod.css
    fi
done