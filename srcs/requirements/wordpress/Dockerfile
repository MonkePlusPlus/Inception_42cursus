
FROM debian:latest

RUN apt update -y && apt upgrade -y && apt install -y php-fpm

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/.

CMD ["php-fpm8.2", "-F"]