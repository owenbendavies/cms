['landrush', 'vagrant-berkshelf', 'vagrant-timezone'].each do |plugin|
  unless Vagrant.has_plugin? plugin
    puts "Run 'vagrant plugin install #{plugin}'"
    exit 1
  end
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
    virtualbox.memory = 2048

    virtualbox.customize [
      'guestproperty',
      'set',
      :id,
      '/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold',
      10_000
    ]
  end

  config.vm.provision 'chef_apply' do |chef|
    chef.recipe = File.read('chef/vagrant.rb')
  end

  config.vm.provision 'chef_solo' do |chef|
    chef.roles_path = 'chef/roles'

    chef.add_role 'development'
  end

  config.vm.provision 'shell', privileged: false, inline: '/vagrant/bin/setup'
end
