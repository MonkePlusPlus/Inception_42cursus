#---------- WORDPRESS ----------

FROM	debian:buster

RUN     apt update -y && \
        apt-get upgrade -y && \
        apt-get install -y php \
        php-mysql \
        php-cli \
        php-mbstring \
        php-fpm \
        php-gettext \
        mariadb-client \
        wget && \
        rm -rf /etc/php/7.3/fpm/pool.d/www.conf && \
        mkdir -p /run/php

COPY    ./conf/www.conf /etc/php/7.3/fpm/pool.d/
COPY    ./tools/run.sh /tmp/

RUN     chmod +x /tmp/run.sh

#EXPOSE	9000

ENTRYPOINT [ "sh", "/tmp/run.sh" ]

