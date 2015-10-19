include cms::development

apt::source { 'heroku':
  include_src => false,
  key         => '0F1B0520',
  key_source  => 'https://toolbelt.heroku.com/apt/release.key',
  location    => 'http://toolbelt.heroku.com/ubuntu',
  release     => '',
  repos       => './',
} ->
package { 'heroku-toolbelt': ensure => present }

file { '/etc/profile.d/vagrant.sh':
  content => 'if [ -n "$BASH_VERSION" ]; then cd /vagrant; fi'
}
