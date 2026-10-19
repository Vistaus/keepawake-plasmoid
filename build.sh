#!/bin/sh
# Package the Keep Awake widget, with its compiled translations, as a .plasmoid file ready to share or
# upload to the KDE Store. The package is assembled in build/keepawake/ first, so the compiled translations
# stay out of the source tree. install.sh installs the .plasmoid file.
#
# Usage:
#   ./build.sh   write build/keepawake/ and build/keepawake.plasmoid
#
# Needs zip, and msgfmt from gettext.

set -e
cd "$(dirname "$0")"

PLUGIN_ID=$(sed -n 's/.*"Id": *"\([^"]*\)".*/\1/p' metadata.json)
PACKAGE_DIR="build/keepawake"
OUTPUT="build/keepawake.plasmoid"

echo "Building $PLUGIN_ID..."
rm -rf "$PACKAGE_DIR" "$OUTPUT"
mkdir -p "$PACKAGE_DIR"
cp -r metadata.json contents LICENSE "$PACKAGE_DIR/"
translate/compile.sh "$PACKAGE_DIR"

(cd "$PACKAGE_DIR" && zip -qr ../keepawake.plasmoid metadata.json contents LICENSE)
echo "Built $OUTPUT"
