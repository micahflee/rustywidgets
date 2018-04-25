#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Paths for building the bundle
BUNDLE_PATH=$DIR/../target/release/bundle/osx/RustyWidgets.app
rm -rf $BUNDLE_PATH

# Create the app bundle
cargo bundle --release

# Copy the GTK libraries into the app bundle
mkdir -p "$BUNDLE_PATH/Contents/Frameworks"
LIB_LIST="gtk+3 atk cairo pango gdk-pixbuf glib fribidi libepoxy gettext harfbuzz fontconfig freetype pcre libffi pixman graphite2"
for LIB in $LIB_LIST; do
  cp -a /usr/local/opt/$LIB/lib/*.dylib "$BUNDLE_PATH/Contents/Frameworks"
done

# Copy other required frameworks
cp -a /System/Library/Frameworks/ImageIO.framework "$BUNDLE_PATH/Contents/Frameworks"

# Copy in the launch script, and update Info.plist
cp $DIR/launch.sh $BUNDLE_PATH/Contents/MacOS/launch.sh
chmod +x $BUNDLE_PATH/Contents/MacOS/launch.sh
sed -i '' -e "s|<string>rustywidgets</string>|<string>launch.sh</string>|g" "$BUNDLE_PATH/Contents/Info.plist"
