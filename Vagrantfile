['landrush', 'vagrant-berkshelf', 'vagrant-timezone'].each do |plugin|
  plugin_manager = Vagrant::Plugin::Manager.instance

  unless Vagrant.has_plugin? plugin
    puts "Installing plugin #{plugin}"
    plugin_manager.install_plugin(plugin)
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
