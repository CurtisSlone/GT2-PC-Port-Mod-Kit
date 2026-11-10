#!/bin/sh
# UGT2R: install Gran Turismo 2 from YOUR OWN disc image into data/, then prepare the tracks and cars.
#   ./install-gt2.sh                     pick the .cue file in a window (zenity or kdialog), else asks for the path
#   ./install-gt2.sh game.cue            install from that image
#   ./install-gt2.sh game.cue verify     compare an existing install with the disc (and repair it)
# Only Gran Turismo 2 (USA) Simulation Mode v1.0 (SCUS-94488) is accepted; any other disc is refused.
# The disc is read once; afterwards the game plays from data/ and the image is not needed.
cd "$(dirname "$0")" || exit 1
APP=./UGT2R-x86_64.AppImage
[ -x "$APP" ] || chmod +x "$APP" 2>/dev/null
# no FUSE (some containers, minimal systems): the AppImage unpacks itself to a temporary folder instead
if ! command -v fusermount3 >/dev/null 2>&1 && ! command -v fusermount >/dev/null 2>&1; then
    export APPIMAGE_EXTRACT_AND_RUN=1
fi

CUE=$1
TITLE="Pick your Gran Turismo 2 (USA) Simulation disc image (.cue)"
if [ -z "$CUE" ] && [ -n "$DISPLAY$WAYLAND_DISPLAY" ]; then
    if command -v zenity >/dev/null 2>&1; then
        CUE=$(zenity --file-selection --title="$TITLE" --file-filter="Disc image (.cue) | *.cue *.CUE" 2>/dev/null)
    elif command -v kdialog >/dev/null 2>&1; then
        CUE=$(kdialog --title "$TITLE" --getopenfilename "$HOME" "*.cue *.CUE|Disc image (.cue)" 2>/dev/null)
    fi
fi
if [ -z "$CUE" ] && [ -t 0 ]; then
    printf 'Path to your disc image (.cue): '
    read -r CUE
fi
if [ -z "$CUE" ]; then
    echo "No disc image picked. Run: ./install-gt2.sh /path/to/game.cue"
    exit 1
fi
if [ ! -f "$CUE" ]; then
    echo "Cannot find the file: $CUE"
    exit 1
fi

failed() {
    echo
    echo "The install did not complete (see the message above). If it says the disc is not known: this release only"
    echo "works with Gran Turismo 2 (USA) Simulation Mode v1.0, SCUS-94488, dumped from your own disc."
    exit 1
}

if [ "$2" = "verify" ]; then
    echo "Checking data/ against: $CUE"
    "$APP" "$CUE" --install-only --verify-data || failed
    echo "The install matches the disc."
else
    echo "Installing from: $CUE"
    echo
    "$APP" "$CUE" --install-only || failed
    mkdir -p cards
    [ -e cards/card1.mcr ] || cp cards/blank.mcd cards/card1.mcr
fi

echo
echo "Building the Grand Tour 99 menus (part of the game, in data/builtin) from your install."
[ -x ./gt2-tools ] || chmod +x ./gt2-tools 2>/dev/null
if ! ./gt2-tools builtin build --data data >/dev/null; then
    echo "The Grand Tour 99 menus were not built (see the message above). The game plays with GT2's own menus."
    echo "To try again: ./gt2-tools builtin build"
fi

echo
echo "Preparing your tracks and cars. This runs once, takes a while and uses several GB in data/scene-cache."
echo "You can stop it (Ctrl+C) and play now instead; anything not ready yet is prepared when the game needs it."
echo
if "$APP" --warmup-all; then
    echo
    echo "Done. Start UGT2R-x86_64.AppImage to play. Your saves go to cards/card1.mcr."
else
    echo
    echo "Preparing the tracks and cars stopped early (see the message above). The game still plays: what is missing"
    echo "is prepared when a race needs it. You can run ./install-gt2.sh again later to finish it."
fi
