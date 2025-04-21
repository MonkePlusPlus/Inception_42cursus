#!/bin/sh

sed -i 's|PHP_PORT|'${PHP_PORT}'|g' /etc/php/7.3/fpm/pool.d/www.conf

if [ -f "/var/www/wordpress/wp-config.php" ]

then
  echo "Wordpress already confiured."

else
  wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x wp-cli.phar
  mv wp-cli.phar /usr/local/bin/wp


 cat > "$WP_PATH/wp-config.php" <<EOF
<?php
define( 'DB_NAME', '${MYSQL_DATABASE}' );
define( 'DB_USER', '${MYSQL_USER}' );
define( 'DB_PASSWORD', '${MYSQL_PASSWORD}' );
define( 'DB_HOST', 'mariadb' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );
\$table_prefix = 'wp_';
define( 'WP_DEBUG', true );
if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}
require_once ABSPATH . 'wp-settings.php';
EOF

  wp core download --path=$WP_PATH --allow-root 
  wp config create \
    --dbname=$MYSQL_DATABASE \
    --dbuser=$MYSQL_USER \
    --dbpass=$MYSQL_PASSWORD \
    --dbhost=mariadb \
    --path=$WP_PATH \
    --skip-check \
    --allow-root 

  wp core install \
    --path=$WP_PATH \
    --url=ptheo.42.fr \
    --title=$WP_TITLE \
    --admin_user=$WP_USER \
    --admin_password=$WP_PASSWORD \
    --admin_email=$WP_EMAIL \
    --skip-email \
    --allow-root


  wp theme install teluro --path=$WP_PATH --activate --allow-root 
  wp user create ptheo ptheo@student.42.fr \
   --role=author --path=$WP_PATH --user_pass=ptheo --allow-root 

fi

/usr/sbin/php-fpm7.3 -F
