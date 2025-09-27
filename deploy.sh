#!/bin/bash

TARGETHOST=echeclus.uberspace.de
TARGETDIR=/var/www/virtual/floppnet/dreierlei.freiburg.run/

mkdir -p static
curl -L https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.classless.min.css -o static/pico.css

ssh $TARGETHOST mkdir -p $TARGETDIR
rsync -av --delete static/ $TARGETHOST:$TARGETDIR
