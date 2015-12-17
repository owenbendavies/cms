unless Vagrant.has_plugin? 'landrush'
  puts "Run 'vagrant plugin install landrush'"
  exit 1
end

unless Vagrant.has_plugin? 'vagrant-timezone'
  puts "Run 'vagrant plugin install vagrant-timezone'"
  exit 1
end

Vagrant.configure(2) do |config|
  config.landrush.enabled = true
  config.landrush.tld = 'dev'
  config.ssh.forward_agent = true
  config.timezone.value = :host
  config.vm.box = 'ubuntu/trusty64'
  config.vm.hostname = 'cms.dev'
  config.vm.network 'private_network', type: 'dhcp'
  config.vm.synced_folder '.', '/vagrant', nfs: true

  config.vm.provider :virtualbox do |virtualbox|
    virtualbox.memory = 1269
  end

  config.vm.provision 'shell', inline: <<-SHELL
    apt-get update
    apt-get install --yes ruby-dev
    gem install librarian-puppet --no-rdoc --no-ri
    cd /vagrant/puppet
    librarian-puppet install
  SHELL

  config.vm.provision 'puppet' do |puppet|
    puppet.manifest_file = 'development.pp'
    puppet.manifests_path = 'puppet/manifests'
    puppet.module_path = ['puppet/modules', 'puppet/modules_custom']
    puppet.synced_folder_type = 'nfs'
  end
end
