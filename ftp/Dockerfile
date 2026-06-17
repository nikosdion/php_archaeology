FROM alpine:3.20

RUN apk add --no-cache pure-ftpd

COPY entrypoint.sh /usr/local/bin/ftp-entrypoint.sh

RUN chmod +x /usr/local/bin/ftp-entrypoint.sh \
  && mkdir -p /etc/pure-ftpd/passwd /run/pure-ftpd /home/ftpusers

EXPOSE 21

ENTRYPOINT ["/usr/local/bin/ftp-entrypoint.sh"]
