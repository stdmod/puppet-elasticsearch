#
# Testing installation from upstream
#
class { 'elasticsearch':
  install => 'upstream',
  version => '0.90.1',
}
