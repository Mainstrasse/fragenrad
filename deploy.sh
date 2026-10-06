#!/bin/zsh
# Veröffentlicht das Spiel auf https://kg-fragenspiel.web.app (Firebase-Projekt fragen-tool).
set -e
cd "${0:A:h}"
rm -rf site && mkdir site
cp index.html manifest.webmanifest sw.js confetti.min.js site/
cp -R icons site/
npx --prefix /Users/immanuel/FragenTool firebase deploy --only hosting --project fragen-tool
