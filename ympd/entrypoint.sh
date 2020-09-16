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

if [[ -n "$SSL_CERT" && -n "$SSL_KEY" ]]; then
    if [[ ! -f "$SSL_CERT" ]]; then
        printf "Error: couldn't find SSL certificate\n"
        exit 1
    fi

    if [[ ! -f "$SSL_KEY" ]]; then
        printf "Error: couldn't find SSL private key\n"
        exit 1
    fi

    cat "$SSL_KEY" "$SSL_CERT" > "/ssl.pem"
    WEBPORT="ssl://8080:/ssl.pem"
else
    WEBPORT="8080"
fi

set -o xtrace
ympd -h "$HOST" -p "$PORT" -w "$WEBPORT"
