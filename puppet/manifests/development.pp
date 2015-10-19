include cms::development

file { '/etc/profile.d/vagrant.sh':
  content => 'if [ -n "$BASH_VERSION" ]; then cd /vagrant; fi'
}
