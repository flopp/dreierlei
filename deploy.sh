#!/bin/bash

FORCE=0

# supported command line arguments:
# --force : force re-download of all files (optional)
# --help|-h: show help
for ARG in "$@"; do
    case $ARG in
        --force)
            FORCE=1
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [--force] [--help|-h]"
            echo "  --force : force re-download of all files (optional)"
            echo "  --help|-h: show this help message"
            exit 0
            ;;
        *)
            echo "Unknown argument: $ARG"
            echo "Use --help or -h for help."
            exit 1
            ;;
    esac
done

TARGETHOST=echeclus.uberspace.de
TARGETDIR=/var/www/virtual/floppnet/dreierlei.freiburg.run/

function download() {
    URL=$1
    DEST=$2
    if [ ! -f "$DEST" ] || [ "$FORCE" -eq 1 ]; then
        echo "Downloading $URL to $DEST"
        mkdir -p "$(dirname "$DEST")"
        curl -L "$URL" -o "$DEST"
    fi
}

download https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.classless.min.css    static/pico.css

# download leaflet
FILES=(leaflet.css leaflet.js images/marker-icon.png images/marker-icon-2x.png images/marker-shadow.png)
for FILE in "${FILES[@]}"; do
    download "https://unpkg.com/leaflet@1.9.4/dist/$FILE" "static/$FILE"
done

# gesture handling for leaflet on mobile
FILES=(leaflet-gesture-handling.min.js leaflet-gesture-handling.min.css)
for FILE in "${FILES[@]}"; do
    download "https://raw.githubusercontent.com/elmarquis/Leaflet.GestureHandling/refs/heads/master/dist/$FILE" "static/$FILE"
done

# umami: https://cloud.umami.is/script.js
download https://cloud.umami.is/script.js static/umami.js

ssh $TARGETHOST mkdir -p $TARGETDIR
rsync -av --delete static/ $TARGETHOST:$TARGETDIR

ssh $TARGETHOST chmod -R 755 $TARGETDIR

