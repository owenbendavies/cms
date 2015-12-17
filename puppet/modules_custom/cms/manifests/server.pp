class cms::server {
  $user = 'rails'

  user { $user:
    ensure     => present,
    managehome => true,
  } ->
  class { 'cms::dependencies':
    user => $user,
  }
}
