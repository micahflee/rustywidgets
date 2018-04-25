#!/bin/bash

# Look for dynamic libraries in the directory of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export DYLD_LIBRARY_PATH=$DIR

# Launch RustyWidgets
$DIR/rustywidgets
