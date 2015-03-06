# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.ssh.forward_agent = true

  config.vm.box = 'ubuntu/trusty64'
  config.vm.hostname = 'cms'
  config.vm.network 'private_network', type: 'dhcp'
  config.vm.synced_folder '.', '/vagrant', nfs: true

  config.vm.provider :virtualbox do |virtualbox|
    virtualbox.memory = 2048
  end

  config.vm.provision 'shell', inline: <<-SHELL
    apt-get update
    apt-get install -y ruby1.9.1-dev
    gem install librarian-puppet --no-rdoc --no-ri
    cd /vagrant/puppet
    librarian-puppet install
  SHELL

  config.vm.provision 'puppet' do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.module_path = 'puppet/modules'
    puppet.synced_folder_type = 'nfs'
  end
end
