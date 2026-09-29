#!/bin/zsh
# Baut Fragenrad.app aus der Webseite im Hauptordner und legt sie in /Applications ab.
#   ./mac/build.sh            bauen und installieren
#   ./mac/build.sh --no-install   nur bauen (mac/build/Fragenrad.app)
set -e
HERE="${0:A:h}"
ROOT="${HERE:h}"
cd "$HERE"
APP="build/Fragenrad.app"

rm -rf build
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources/web/icons"

swiftc -O -swift-version 5 -target arm64-apple-macos12.3 main.swift -o build/Fragenrad-arm64
swiftc -O -swift-version 5 -target x86_64-apple-macos12.3 main.swift -o build/Fragenrad-x86_64
lipo -create build/Fragenrad-arm64 build/Fragenrad-x86_64 -output "$APP/Contents/MacOS/Fragenrad"
rm build/Fragenrad-arm64 build/Fragenrad-x86_64

cp Info.plist "$APP/Contents/Info.plist"
cp AppIcon.icns "$APP/Contents/Resources/AppIcon.icns"
cp "$ROOT/index.html" "$ROOT/confetti.min.js" "$APP/Contents/Resources/web/"
cp "$ROOT"/icons/*.png "$APP/Contents/Resources/web/icons/"

codesign --force --deep --sign - "$APP"

if [[ "$1" != "--no-install" ]]; then
  pkill -x Fragenrad 2>/dev/null || true
  rm -rf /Applications/Fragenrad.app
  cp -R "$APP" /Applications/
  echo "Installiert: /Applications/Fragenrad.app"
fi
