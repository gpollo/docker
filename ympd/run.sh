#!/bin/bash

if [[ -n $MPD_HOST ]]; then
    HOST="$MPD_HOST"
else
    HOST="mpd"
fi

if [[ -n $MPD_PORT ]]; then
    PORT="$MPD_PORT"
else
    PORT="6600"
fi

if [[ -n $SSL ]]; then
    WEBPORT="-w $SSL"
else
    WEBPORT=""
fi

set -o xtrace
ympd -h "$HOST" -p "$PORT" -w 8080 $WEBPORT


