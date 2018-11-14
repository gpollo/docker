FROM alpine:3.8

# update coreutils for `date -d`
RUN apk add --update coreutils \
 && rm -rf /var/cache/apk/*

# install dependencies
RUN apk add git gcc libc-dev shadow bash

# build and install mcrcon
WORKDIR "/"
RUN git clone "https://github.com/tiiffi/mcrcon.git" \
 && cd "/mcrcon" \
 && gcc -std=gnu11 -pedantic -Wall -Wextra -O2 -s -o "mcrcon" "mcrcon.c" \
 && cp "mcrcon" "/bin/"

# create user
RUN groupadd -r docker \
 && useradd -r -g docker -d "/docker" -s "/bin/sh" docker

# create backup folder
RUN mkdir "/backup"

# start the backup script
COPY "entrypoint.sh" "/"
ENTRYPOINT ["/entrypoint.sh", "system"]
