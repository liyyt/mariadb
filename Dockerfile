FROM alpine:latest
MAINTAINER Aaron Bolanos <aaron@liyyt.com>

ENV LC_ALL=en_GB.UTF-8

RUN addgroup -S mysql && \
    adduser -S mysql -G mysql && \
    apk -U upgrade && \
    apk add --no-cache mariadb mariadb-client && \
    mkdir /docker-entrypoint-initdb.d && \
    sed -Ei 's/^(bind-address|log)/#&/' /etc/mysql/my.cnf && \
    echo -e 'skip-host-cache\nskip-name-resolve' | awk '{ print } $1 == "[mysqld]" && c == 0 { c = 1; system("cat") }' /etc/mysql/my.cnf > /tmp/my.cnf && \
    mv /tmp/my.cnf /etc/mysql/my.cnf && \

    rm -rf /tmp/src && \
    rm -rf /var/cache/apk/*

VOLUME /var/lib/mysql

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 3306