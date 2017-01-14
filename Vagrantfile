plugins = ['landrush', 'vagrant-timezone']
missing_plugins = plugins.reject { |plugin| Vagrant.has_plugin? plugin }

if missing_plugins.any?
  system 'vagrant', 'plugin', 'install', *missing_plugins
  exec 'vagrant', *ARGV
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
    virtualbox.memory = 1024

    virtualbox.customize [
      'guestproperty',
      'set',
      :id,
      '/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold',
      10_000
    ]
  end

  config.vm.provision 'ansible_local' do |ansible|
    ansible.galaxy_role_file = 'provisioning/requirements.yml'
    ansible.playbook = 'provisioning/playbook.yml'
  end

  config.vm.provision 'shell', privileged: false, inline: '/vagrant/bin/setup'
end
