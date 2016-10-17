# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty64"

  # Hostname
  config.vm.hostname = "dev.local"

  # VirtualBox machine name
  config.vm.define "dev.local" do |dev|
  end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "10.0.1.4"
  config.vm.network :forwarded_port, host: 8080, guest: 80
  config.vm.network :forwarded_port, host: 8443, guest: 443
  #config.vm.network :forwarded_port, host: 8001, guest: 8001
  #config.vm.network :forwarded_port, host: 8002, guest: 8002
  #config.vm.network :forwarded_port, host: 8003, guest: 8003

  if RUBY_PLATFORM.downcase.match(/darwin/)
    config.trigger.after [:provision, :up, :reload] do
      system('echo "
      rdr pass inet proto tcp from any to any port 80 -> 127.0.0.1 port 8080
      rdr pass inet proto tcp from any to any port 443 -> 127.0.0.1 port 8443
      " | sudo pfctl -ef - > /dev/null 2>&1; echo "==> Fowarding Ports: 80 -> 8080, 443 -> 8443 & Enabling pf"')
    end

    config.trigger.after [:halt, :destroy] do
      system("sudo pfctl -df /etc/pf.conf > /dev/null 2>&1; echo '==> Removing Port Forwarding & Disabling pf'")
    end
  end

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "./sites", "/var/www/html",
    type: "rsync",
    owner: "www-data",
    group: "www-data",
    rsync__exclude: [".git/", "_dev/"]

  # Configure the window for gatling to coalesce writes.
  if Vagrant.has_plugin?("vagrant-gatling-rsync")
    config.gatling.latency = 1.5
    config.gatling.time_format = "%H:%M:%S"
  end

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
    # Customize the amount of memory on the VM:
    vb.memory = "1024"

    # VirtualBox GUI name:
    vb.name = "vagrant_dev.local"

    # Some Customizations:
    vb.customize [
      'modifyvm', :id,
      '--chipset', 'ich9',
      '--paravirtprovider', 'kvm'
    ]
  end

  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", path: "provisioner.sh"
end
