#!/bin/sh
# Install, upgrade or remove the Keep Awake widget, then reload plasmashell. Installing runs build.sh first
# and installs the .plasmoid file it writes to build/.
#
# Usage:
#   ./install.sh          install the widget, or upgrade it if it is already installed
#   ./install.sh remove   uninstall the widget
#
# Needs zip, and msgfmt from gettext.

set -e
cd "$(dirname "$0")"

ACTION=${1:-install}
case "$ACTION" in
    install|remove) ;;
    *) echo "usage: $0 [install|remove]" >&2; exit 1 ;;
esac

PLUGIN_ID=$(sed -n 's/.*"Id": *"\([^"]*\)".*/\1/p' metadata.json)
PACKAGE="build/keepawake.plasmoid"

if [ "$ACTION" = remove ]; then
    echo "Removing $PLUGIN_ID..."
    kpackagetool6 -t Plasma/Applet --remove "$PLUGIN_ID"
else
    ./build.sh
    echo "Installing $PLUGIN_ID..."
    kpackagetool6 -t Plasma/Applet --upgrade "$PACKAGE" >/dev/null 2>&1 \
        || kpackagetool6 -t Plasma/Applet --install "$PACKAGE"
fi

echo "Reloading plasmashell..."
systemctl --user restart plasma-plasmashell.service
