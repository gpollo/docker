FROM alpine:latest AS cloner
RUN apk add git \
 && cd / \
 && git clone https://github.com/killemov/Shift shift

FROM linuxserver/transmission:latest
RUN rm -rvf /usr/share/transmission/web/*
COPY --from=cloner /shift/* /usr/share/transmission/web/
