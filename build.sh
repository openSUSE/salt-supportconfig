#!/bin/bash
#
# Please blame for this: bo@suse.de
#


#
# Get version of the build
#
function get_version() {
    echo $(cat VERSION)
}


#
# Prepare the environment
#
function prepare() {
    target=$1;
    if [ -d "$target" ]; then
	rm -rf $target
    fi

    mkdir $target
    cp src/salt* $target
    cp LICENSE $target
    cp VERSION $target

    echo "Prepared $target"
}

#
# Cleanup
#
function cleanup() {
    target=$1
    if [ -d "$target" ]; then
	rm -rf $target
    fi

    echo "Cleaned up"
}

#
# Check error
#
function is_error() {
    if [ $? -ne 0 ]; then
	echo "Error $1. Exiting"
	exit 1;
    fi
}

#
# Make a tarball
#
function tar_it_up() {
    target=$1
    tar zcvf - $target > "$target.tar.gz" 2>/dev/null
    is_error "archiving"

    echo "Created $target.tar.gz"
}


#
# Main
#
function main() {
    if [ ! -f VERSION ]; then
	>&2 echo 'Where is the "VERSION" file?.. Change directory to the root of the project!'
	exit 1;
    fi
    target="salt-supportconfig-plugins-$(get_version)"
    prepare $target;
    tar_it_up $target;
    cleanup $target;
}

main;
