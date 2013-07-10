# Class: elasticsearch::params
#
# Defines all the variables used in the module.
#
class elasticsearch::params {

  $install_base_url = 'https://download.elasticsearch.org/elasticsearch/elasticsearch/'

  $package = 'elasticsearch'

  $service = 'elasticsearch'

  $service_subscribe = Class['elasticsearch::config']

  $file = $::osfamily ? {
    default => '/etc/elasticsearch/elasticsearch.yml',
  }

  $init_options_file = $::osfamily ? {
    Debian  => '/etc/default/elasticsearch',
    default => '/etc/sysconfig/elasticsearch',
  }

  $file_mode = '0644'

  $file_owner = 'root'

  $file_group = 'root'

  $dir = $::osfamily ? {
    default => '/etc/elasticsearch/',
  }

}
