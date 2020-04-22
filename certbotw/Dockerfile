FROM golang:latest AS builder
WORKDIR /build
ADD main.go go.mod ./
RUN go build -o certbotw

FROM certbot/certbot:latest AS deploy
COPY --from=builder /build/certbotw /usr/bin/
ENTRYPOINT /usr/bin/certbotw
