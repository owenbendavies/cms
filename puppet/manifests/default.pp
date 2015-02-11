include vim

include postgresql::client
include postgresql::server

postgresql::server::role { 'cms_development':
  createdb      => true,
  password_hash => postgresql_password('cms_development', 'password'),
}

postgresql::server::role { 'cms_test':
  createdb      => true,
  password_hash => postgresql_password('cms_test', 'password'),
}

class { 'postgresql::lib::devel': link_pg_config => false }

package {
  [
    'imagemagick',
    'libffi-dev',
    'libqtwebkit-dev',
    'redis-server',
    'xvfb',
  ]:
    ensure => present,
}

require rbenv
rbenv::plugin { 'sstephenson/ruby-build': }
rbenv::build { '2.2.0': }
