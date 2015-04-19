import 'shared.pp'

user { 'rails':
  ensure     => present,
  managehome => true,
}
