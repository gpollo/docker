FROM alpine:latest AS builder
RUN apk add musl-dev boost-dev pulseaudio-dev flac-dev libvorbis-dev \
            ffmpeg-dev wavpack-dev git meson ninja g++ \
 && git clone https://github.com/MusicPlayerDaemon/MPD /mpd \
 && cd /mpd \
 && meson build -Dpulse=enabled -Dflac=enabled -Dwavpack=enabled \
                -Dvorbis=enabled -Dvorbisenc=enabled -Dffmpeg=enabled \
                -Dhttpd=true -Ddaemon=false \
 && cd /mpd/build \
 && ninja

FROM alpine:latest AS deploy
RUN apk add musl boost pulseaudio pulseaudio-utils flac libvorbis ffmpeg \
        wavpack dbus-x11 consolekit shadow xvfb mpd \
 && dbus-uuidgen --ensure=/etc/machine-id

RUN addgroup -S mpduser \
 && adduser -D -S -h /mpd -s /bin/sh -G audio -G mpduser mpduser \
 && usermod -a -G audio mpduser \
 && mkdir -p /log \
 && chmod -Rv o+w /log

COPY mpd.conf /
COPY entrypoint.sh /
COPY --from=builder /mpd/build/mpd /usr/bin/mpd

EXPOSE 6600
ENTRYPOINT ["/entrypoint.sh", "system"]
