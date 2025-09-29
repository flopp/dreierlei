#!/bin/bash

TARGETHOST=echeclus.uberspace.de
TARGETDIR=/var/www/virtual/floppnet/dreierlei.freiburg.run/

if [ ! -f static/pico.css ]; then
    echo "Downloading pico.css"
    mkdir -p static
    curl -L https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.classless.min.css -o static/pico.css
fi

# download leaflet
FILES=(leaflet.css leaflet.js images/marker-icon.png images/marker-icon-2x.png images/marker-shadow.png)
for FILE in "${FILES[@]}"; do
    if [ ! -f "static/$FILE" ]; then
        mkdir -p "static/$(dirname $FILE)"
        echo "Downloading $FILE"
        curl -L "https://unpkg.com/leaflet@1.9.4/dist/$FILE" -o "static/$FILE"
    fi
done

# gesture handling for leaflet on mobile
FILES=(leaflet-gesture-handling.min.js leaflet-gesture-handling.min.css)
for FILE in "${FILES[@]}"; do
    if [ ! -f "static/$FILE" ]; then
        mkdir -p "static/$(dirname $FILE)"
        echo "Downloading $FILE"
        curl -L "https://raw.githubusercontent.com/elmarquis/Leaflet.GestureHandling/refs/heads/master/dist/$FILE" -o "static/$FILE"
    fi
done

ssh $TARGETHOST mkdir -p $TARGETDIR
rsync -av --delete static/ $TARGETHOST:$TARGETDIR

ssh $TARGETHOST chmod -R 755 $TARGETDIR

