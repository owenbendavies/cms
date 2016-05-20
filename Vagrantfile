['landrush', 'vagrant-berkshelf', 'vagrant-timezone'].each do |plugin|
  unless Vagrant.has_plugin? plugin
    puts "Run 'vagrant plugin install #{plugin}'"
    exit 1
  end
end

PROJECT_RUBY_VERSION = File.read('.ruby-version').strip

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

  config.vm.provision 'chef_apply' do |chef|
    chef.recipe = File.read('chef/vagrant.rb')
  end

  config.vm.provision 'chef_solo' do |chef|
    chef.version = '12.10.40'

    chef.add_recipe 'postgresql::server'
    chef.add_recipe 'ruby_build'
    chef.add_recipe 'ruby_rbenv::user'

    chef.json = {
      postgresql: {
        password: {
          postgres: 'password'
        },
        pg_hba: [{
          type: 'host',
          db: 'all',
          user: 'all',
          addr: '127.0.0.1/32',
          method: 'trust'
        }]
      },
      rbenv: {
        user_installs: [{
          user: 'vagrant',
          rubies: [PROJECT_RUBY_VERSION],
          global: PROJECT_RUBY_VERSION,
          gems: {
            PROJECT_RUBY_VERSION => [
              { name: 'bundler' }
            ]
          }
        }]
      }
    }
  end

  config.vm.provision 'shell', privileged: false, inline: '/vagrant/bin/setup'
end
