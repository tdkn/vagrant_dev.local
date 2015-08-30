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
  mysql-server mysql-client \
  phpmyadmin \
  zsh tmux \
  git tig \
  curl

# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    ServerName dev.local
    ServerAlias *.dev.local
    VirtualDocumentRoot "/var/www/html/%-3+"
    <Directory "/var/www/html/">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>

<VirtualHost *:80>
    ServerAlias *.local
    VirtualDocumentRoot "/var/www/html/%-2+"
    <Directory "/var/www/html/">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

# Enable apache rewrite module.
#--------------------------------------------------
a2enmod rewrite
a2enmod vhost_alias

# Restart apache.
#--------------------------------------------------
service apache2 restart
