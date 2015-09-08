class cms::development {
  include cms::dependencies
  include docker

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

  postgresql::server::role { 'cms_development':
    createdb      => true,
    password_hash => postgresql_password('cms_development', 'password'),
  }

  postgresql::server::role { 'cms_test':
    createdb      => true,
    password_hash => postgresql_password('cms_test', 'password'),
  }
}
