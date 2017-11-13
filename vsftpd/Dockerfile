FROM alpine:latest

# install vsftpd
RUN apk update && apk add vsftpd

# expose standard ftp ports
EXPOSE 20 21 10090-10100

# add the starting script
ADD entrypoint.sh /

# container's command
CMD ["/entrypoint.sh"]
