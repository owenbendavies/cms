class cms::development {
  class { 'cms::dependencies':
    user => 'vagrant',
  }

  package {
    [
      'libqt5webkit5-dev',
      'qt5-default',
      'redis-server',
      'xvfb',
    ]:
  }

  include postgresql::client
  include postgresql::server

  postgresql::server::pg_hba_rule { 'trust localhost TCP access to all users':
    type        => 'host',
    database    => 'all',
    user        => 'all',
    address     => '127.0.0.1/32',
    auth_method => 'trust',
    order       => '002',
  }
}
