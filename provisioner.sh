#!/usr/bin/env bash

# character passwords
#--------------------------------------------------
MYSQL_PASSWORD='password'
PMA_PASSWORD='password'

# Set mysql password.
debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_PASSWORD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_PASSWORD"

# Set phpMyAdmin password.
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PMA_PASSWORD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PMA_PASSWORD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PMA_PASSWORD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"

# Update apt package list.
#--------------------------------------------------
apt-get update

# Install essential web development tools.
#--------------------------------------------------
apt-get install -y \
  apache2 \
  php5 php5-mysql \
  sqlite3 php5-sqlite \
  mysql-server mysql-client \
  phpmyadmin \
  zsh tmux \
  git tig \
  curl

# setup hosts file
VHOST=$(cat <<EOF
<Directory "/var/www/html/">
    AllowOverride All
    Require all granted
</Directory>

#Listen 8001
#Listen 8002
#Listen 8003
#
#<VirtualHost *:80>
#    DocumentRoot "/var/www/html/default.example.com"
#    php_admin_value auto_prepend_file /var/www/html/document_root.php
#</VirtualHost>
#
#<VirtualHost *:8001>
#    DocumentRoot "/var/www/html/site1.example.com"
#</VirtualHost>
#
#<VirtualHost *:8002>
#    DocumentRoot "/var/www/html/site2.example.com"
#</VirtualHost>
#
#<VirtualHost *:8003>
#    DocumentRoot "/var/www/html/site3.example.com"
#</VirtualHost>

<VirtualHost *:80>
    ServerName dev.local
    ServerAlias *.dev.local
    VirtualDocumentRoot "/var/www/html/%-3+"
    php_admin_value auto_prepend_file /var/www/html/document_root.php
</VirtualHost>

<VirtualHost *:80>
    ServerAlias *.local
    VirtualDocumentRoot "/var/www/html/%-2+"
    php_admin_value auto_prepend_file /var/www/html/document_root.php
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

# Enable apache modules.
#--------------------------------------------------
a2enmod rewrite
a2enmod vhost_alias
a2disconf javascript-common

# Restart apache.
#--------------------------------------------------
service apache2 restart
