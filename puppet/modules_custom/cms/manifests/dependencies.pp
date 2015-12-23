class cms::dependencies($user) {
  package { 'imagemagick': }

  class { 'postgresql::lib::devel': link_pg_config => false }

  rbenv::install { $user: }

  rbenv::compile { '2.2.4':
    user => $user,
  }
}
