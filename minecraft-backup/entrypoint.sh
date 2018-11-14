#!/bin/bash

systemmode() {
    # change the UID/GID of the main user
    if [[ -n "$PUID" ]]; then
        usermod -u $PUID docker
    fi
    if [[ -n "$PGID" ]]; then
        groupmod -g $PGID docker
    fi

    # make sure the address is specified
    if [[ -z "$RCON_ADDR" ]]; then
        echo "ERROR: \`RCON_ADDR\` isn't defined"
        exit 1
    fi

    # make sure the port is specified
    if [[ -z "$RCON_PORT" ]]; then
        echo "ERROR: \`RCON_PORT\` isn't defined"
        exit 1
    fi

    # make sure the password is specified
    if [[ -z "$RCON_PASS" ]]; then
        echo "ERROR: \`RCON_PASS\` isn't defined"
        exit 1
    fi

    # make sure the password is specified
    if [[ -z "$WORLD_NAME" ]]; then
        echo "ERROR: \`WORLD_NAME\` isn't defined"
        exit 1
    fi

    # make sure the world directory exists
    if [[ ! -d "/minecraft/$WORLD_NAME" ]]; then
        echo "ERROR: directory \`$WORLD_NAME\` not found in `/minecraft`"
        exit 1
    fi

    # make sure the backup directory exists
    if [[ ! -d "/minecraft/backup" ]]; then
        echo "ERROR: directory \`backup\` not found in `/minecraft`"
        exit 1
    fi

    # fix permissions
    chown -v docker:docker "/minecraft"

    # start the user script
    su docker -c "/entrypoint.sh user" 
}

usermode() {
    # go to the minecraft folder
    cd "/minecraft"
    
    # high compression
    export GZIP=-9   

    # backup loop
    while true
    do
        # change the server to read-only
        mcrcon -c -H "$RCON_ADDR" -P "$RCON_PORT" -p "$RCON_PASS" \
            "say Starting backup..." \
            "save-off"

        # create the backup name
        DATE=$(date "+%Y%m%d-%H%M%S")
        BACKUP=$(printf "%s-%s.tar.gz" "$WORLD_NAME" "$DATE")

        # create backup archive
        tar cvzf "$BACKUP" "$WORLD_NAME"

        # move backup archive
        mv "$BACKUP" "backup"

        # get next backup date
        DATE=$(date "+%Y/%m/%d %H:%M:%S" -d "+1 day")

        # change the server to read-write
        mcrcon -c -H "$RCON_ADDR" -P "$RCON_PORT" -p "$RCON_PASS" \
            "say Backup done, created $BACKUP" \
            "say Next backup is scheduled at $DATE" \
            "save-on"

        # wait for the next backup
        sleep 1d
    done

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
