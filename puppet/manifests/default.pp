package {
  [
    'imagemagick',
    'libqt5webkit5-dev',
    'qt5-default',
    'redis-server',
    'xvfb',
  ]:
}

rbenv::install { 'vagrant': }
rbenv::compile { '2.2.4': user => 'vagrant' }

include postgresql::client
include postgresql::server

class { 'postgresql::lib::devel': link_pg_config => false }

postgresql::server::pg_hba_rule { 'trust localhost TCP access to all users':
  type        => 'host',
  database    => 'all',
  user        => 'all',
  address     => '127.0.0.1/32',
  auth_method => 'trust',
  order       => '002',
}
