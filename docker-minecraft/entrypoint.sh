#!/bin/bash

systemmode() {
    # change the UID/GID of the main user
    if [ -n "$PUID" ]; then
        usermod -u $PUID minecraft
    fi
    if [ -n "$PGID" ]; then
        groupmod -g $PGID minecraft
    fi

    # fix permissions
    chown -Rv minecraft:minecraft "/minecraft"

    # start the user script
    su minecraft -c "/entrypoint.sh user" 
}

usermode() {
    # run the server
    java -jar $FORGE_SERVER nogui
}

case "$1" in
    "system")
        systemmode
        ;;
    "user")
        usermode
        ;;
    *)
        echo "ERROR: unrecognized mode \"$1\""
        exit
        ;;
esac
