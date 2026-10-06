#!/bin/zsh
# Baut Fragenspiel.app aus der Webseite im Hauptordner und legt sie in /Applications ab.
#   ./mac/build.sh            bauen und installieren
#   ./mac/build.sh --no-install   nur bauen (mac/build/Fragenspiel.app)
set -e
HERE="${0:A:h}"
ROOT="${HERE:h}"
cd "$HERE"
APP="build/Fragenspiel.app"

rm -rf build
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources/web/icons"

swiftc -O -swift-version 5 -target arm64-apple-macos12.3 main.swift -o build/Fragenspiel-arm64
swiftc -O -swift-version 5 -target x86_64-apple-macos12.3 main.swift -o build/Fragenspiel-x86_64
lipo -create build/Fragenspiel-arm64 build/Fragenspiel-x86_64 -output "$APP/Contents/MacOS/Fragenspiel"
rm build/Fragenspiel-arm64 build/Fragenspiel-x86_64

cp Info.plist "$APP/Contents/Info.plist"
cp AppIcon.icns "$APP/Contents/Resources/AppIcon.icns"
cp "$ROOT/index.html" "$ROOT/confetti.min.js" "$APP/Contents/Resources/web/"
cp "$ROOT"/icons/*.png "$APP/Contents/Resources/web/icons/"

codesign --force --deep --sign - "$APP"

if [[ "$1" != "--no-install" ]]; then
  pkill -x Fragenspiel 2>/dev/null || true
  pkill -x Fragenrad 2>/dev/null || true
  rm -rf /Applications/Fragenspiel.app /Applications/Fragenrad.app   # Fragenrad.app = alter Name
  cp -R "$APP" /Applications/
  echo "Installiert: /Applications/Fragenspiel.app"
fi
