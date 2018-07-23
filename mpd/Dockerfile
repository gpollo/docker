FROM alpine:latest
LABEL autors="@TheNiceGuy"

# install dependencies
RUN apk --no-cache add pulseaudio pulseaudio-utils dbus-x11 consolekit shadow xvfb

# install MPD with pulseaudio support built-in
COPY "mpd-0.20.20-r1.apk" "/"
RUN apk add --allow-untrusted "mpd-0.20.20-r1.apk"

# setup user and directories
RUN addgroup -S mpduser \
 && adduser -D -S -h "/mpd" -s "/bin/sh" -G audio -G mpduser mpduser \
 && usermod -a -G audio mpduser \
 && mkdir -p "/log" \
 && chmod -Rv o+w "/log"

# copy base configuration
COPY "mpd.conf" "/"

# copy the entrypoint of this container
COPY "entrypoint.sh" "/"

# expose MPD's control port
EXPOSE 6600

ENTRYPOINT ["/entrypoint.sh", "system"]
