#!/bin/sh

CONFIG="/config"
LOG="/log"

genconfig() {
    echo "#!/usr/bin/pulseaudio -nF"
    echo "load-module module-native-protocol-tcp"
    echo "load-module module-null-sink sink_name=rtp format=s16be channels=2 rate=44100"
    echo "load-module module-rtp-send source=rtp.monitor destination_ip=$DESTINATION"
    echo "set-default-sink rtp"
}

systemmode() {
    # change the UID/GID of the main user
    usermod -u $PUID mpduser
    groupmod -g $PGID mpduser

    # copy mpd files
    if [ ! -f "$CONFIG/mpd.conf" ]; then
        echo "LOG: mpd.conf isn't detected, copying template..."
        cp -v "/mpd.conf" "$CONFIG/mpd.conf"
    fi

    # fix permissions
    chown -Rv mpduser:mpduser "/mpd"

    # create the X11 temp directory
    mkdir -p       "/tmp/.X11-unix"
    chmod -Rv 1777 "/tmp/.X11-unix"

    # generate pulseaudio's config
    if [ -z ${DESTINATION+x} ]; then
	echo "ERROR: variable \$DESTINATION isn't defined"
        exit
    fi
    genconfig > "/etc/pulse/default.pa"

    # start the D-Bus daemon
    dbus-daemon --system --fork

    # start the user script
    su mpduser -c "/entrypoint.sh user"
}

usermode() {
    # we need this to fake an X11 display
    export DISPLAY=1
    Xvfb :1 &

    # launch D-Bus for this user
    dbus-launch pulseaudio --start  --verbose -vvvv --log-target "file://$LOG/pulseaudio.log"

    # launch the MPD server
    mpd --no-daemon --verbose "$CONFIG/mpd.conf" | tee "$LOG/mpd.log"
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


