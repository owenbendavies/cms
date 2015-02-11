# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'ubuntu/trusty64'

  config.vm.network 'private_network', ip: '192.168.33.10'

  config.ssh.forward_agent = true

  config.vm.synced_folder '.', '/vagrant', nfs: true

  config.vm.provision 'shell', inline: 'apt-get install -y ruby1.9.1-dev'
  config.vm.provision 'shell', inline: 'gem install librarian-puppet --no-rdoc --no-ri'
  config.vm.provision 'shell', inline: 'cd /vagrant/puppet && librarian-puppet install'

  config.vm.provision 'puppet' do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.module_path = 'puppet/modules'
    puppet.synced_folder_type = 'nfs'
  end
end
