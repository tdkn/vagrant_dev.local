# Web development environment

## Platform
- ubuntu/trusty64

## Usage

### 1. Install VirtualBox & Vagrant.

- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant](https://www.vagrantup.com/downloads.html)

### 2. Install Vagrant plugin.

`$ vagrant plugin install vagrant-triggers`

### 3. Set Proxy Auto-Configuration (.pac) file

- [OS X Yosemite: Enter proxy server settings](https://support.apple.com/kb/PH18553?locale=ja_JP)
- https://github.com/tdkn/dotfiles/blob/master/.proxy.pac

### 4. Clone repository & vagrant up.

```
$ git clone https://github.com/tdkn/vagrant_dev.local.git
$ cd vagrant_dev.local
$ vagrant up
```

### 5. Put your web sites

```
$ cd vagrant_dev.local/sites
$ mkdir test.com
$ echo "It Works." > test.com/index.html
```

### 6. Sync

`$ vagrant rsync-auto`

### 7. Check at the following URL

`http://test.com.local/`

## Option

### Port based VirtualHosts

Uncomment the following lines :

**Vagrantfile**

```ruby
#config.vm.network :forwarded_port, host: 8001, guest: 8001
#config.vm.network :forwarded_port, host: 8002, guest: 8002
#config.vm.network :forwarded_port, host: 8003, guest: 8003
```

**provisioner<i></i>.sh**

```apache
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
```

## Installed Packages
- apache2
- php5
- php5-mysql
- sqlite3
- php5-sqlite
- mysql-server
- mysql-client
- phpmyadmin
- zsh
- tmux
- git
- tig
- curl
