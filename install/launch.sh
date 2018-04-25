#!/bin/bash

BUNDLE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && cd .. && pwd )"
FRAMEWORKS_DIR="$BUNDLE_DIR/Contents/Frameworks"
EXEC_DIR="$BUNDLE_DIR/Contents/MacOS"

# Look for dynamic libraries in the frameworks directory
export DYLD_LIBRARY_PATH=$FRAMEWORKS_DIR:$FRAMEWORKS_DIR/ImageIO.framework/Resources

# Launch RustyWidgets
$EXEC_DIR/rustywidgets
