class cms::dependencies {
  package { 'imagemagick': }

  class { 'postgresql::lib::devel': link_pg_config => false }

  require rbenv
  rbenv::plugin { 'sstephenson/ruby-build': }
  rbenv::build { '2.2.1': }
}
