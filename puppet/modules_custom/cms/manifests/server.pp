class cms::server {
  include cms::dependencies

  user { 'rails':
    ensure     => present,
    managehome => true,
  }
}
