FROM alpine:latest AS builder
RUN apk add openssl-dev libmpdclient-dev git cmake make gcc g++ \
 && git clone https://github.com/notandy/ympd /ympd \
 && mkdir -p /ympd/build \
 && cd /ympd/build \
 && cmake .. \
 && make

FROM alpine:latest AS deploy
RUN apk add openssl libmpdclient bash

COPY entrypoint.sh /
COPY --from=builder /ympd/build/ympd /usr/bin/ympd

EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
