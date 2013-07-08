# Class: elasticsearch::spec
#
# This class is used only for rpsec-puppet tests
# Can be taken as an example on how to do custom classes but should not
# be modified.
#
# == Usage
#
# This class is not intended to be used directly.
# Use it as reference
#
class elasticsearch::spec {

file { 'my_config':
    ensure  => present,
    path    => '/etc/elasticsearch/my_config',
    content => 'my_content',
  }

}
