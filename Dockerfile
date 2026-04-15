FROM alpine:3.20

RUN apk add --no-cache \
    postfix \
    dovecot \
    dovecot-lmtpd \
    dovecot-pigeonhole-plugin \
    rspamd \
    redis \
    supervisor \
    bash \
    ca-certificates \
    tzdata \
    openssl \
    cyrus-sasl

RUN mkdir -p \
    /etc/rspamd \
    /var/lib/rspamd \
    /var/run/rspamd \
    /var/log/rspamd \
    /var/spool/postfix \
    /var/spool/postfix/private \
    /var/mail/vhosts \
    /etc/dovecot/conf.d

RUN addgroup -S mail && adduser -S mail -G mail || true
RUN addgroup -S postfix && adduser -S postfix -G postfix || true
RUN addgroup -S dovecot && adduser -S dovecot -G dovecot || true

RUN chown -R dovecot:mail /var/mail/vhosts

COPY configs/postfix/ /etc/postfix/
COPY configs/dovecot/ /etc/dovecot/
COPY configs/rspamd/ /etc/rspamd/
COPY supervisord.conf /etc/supervisord.conf

EXPOSE 25 587 143 993

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
