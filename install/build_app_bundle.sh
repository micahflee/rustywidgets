#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Paths for building the bundle
BUNDLE_PATH=target/release/bundle/osx/RustyWidgets.app
LIB_PATH_GTK=/usr/local/Cellar/gtk+3/3.22.30/lib
LIB_PATH_ATK=/usr/local/opt/atk/lib

# Create the app bundle
cargo bundle --release

# Copy the GTK libraries into the app bundle
cp -r $LIB_PATH_GTK/*.dylib $BUNDLE_PATH/Contents/MacOS
cp -r $LIB_PATH_ATK/*.dylib $BUNDLE_PATH/Contents/MacOS

# Copy in the launch script, and update Info.plist
cp $DIR/launch.sh $BUNDLE_PATH/Contents/MacOS/launch.sh
sed -i "s|<string>rustywidgets</string>|<string>launch.sh</string>|g" $BUNDLE_PATH/Contents/Info.plist
