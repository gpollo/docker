FROM alpine:latest
LABEL autors="@TheNiceGuy"

RUN apk --no-cache add pulseaudio pulseaudio-utils dbus-x11 consolekit shadow xvfb

COPY "mpd-0.20.20-r1.apk" "/"
RUN apk add --allow-untrusted "mpd-0.20.20-r1.apk"

RUN addgroup -S mpduser \
 && adduser -D -S -h "/mpd" -s "/bin/sh" -G audio -G mpduser mpduser \
 && usermod -a -G audio mpduser \
 && mkdir -p "/log" \
 && chmod -Rv o+w "/log"

COPY "mpd.conf" "/"
COPY "entrypoint.sh" "/"

EXPOSE 6600

ENTRYPOINT ["/entrypoint.sh", "system"]
