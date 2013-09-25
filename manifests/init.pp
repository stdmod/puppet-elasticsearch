#
# = Class: elasticsearch
#
# This class installs and manages elasticsearch
#
#
# == Parameters
#
# Refer to the official documentation for standard parameters usage.
# Look at the code for the list of supported parametes and their defaults.
#
class elasticsearch (

  $ensure              = 'present',
  $version             = undef,
  $audit               = undef,
  $noop                = undef,

  $install             = 'package',
  $install_base_url    = $elasticsearch::params::install_base_url,
  $install_source      = undef,
  $install_destination = '/opt',

  $user                = 'elasticsearch',
  $user_create         = true,
  $user_uid            = undef,
  $user_gid            = undef,
  $user_groups         = undef,

  $java_heap_size      = '1024',

  $package             = $elasticsearch::params::package,
  $package_provider    = undef,

  $service             = $elasticsearch::params::service,
  $service_ensure      = 'running',
  $service_enable      = true,
  $service_subscribe   = $elasticsearch::params::service_subscribe,
  $service_provider    = undef,

  $init_script_file           = '/etc/init.d/elasticsearch',
  $init_script_file_template  = 'elasticsearch/init.erb',
  $init_options_file          = $elasticsearch::params::init_options_file,
  $init_options_file_template = 'elasticsearch/init_options.erb',

  $file                = $elasticsearch::params::file,
  $file_owner          = $elasticsearch::params::file_owner,
  $file_group          = $elasticsearch::params::file_group,
  $file_mode           = $elasticsearch::params::file_mode,
  $file_replace        = $elasticsearch::params::file_replace,
  $file_source         = undef,
  $file_template       = undef,
  $file_content        = undef,
  $file_options_hash   = undef,

  $dir                 = $elasticsearch::params::dir,
  $dir_source          = undef,
  $dir_purge           = false,
  $dir_recurse         = true,

  $dependency_class    = 'elasticsearch::dependency',
  $my_class            = undef,

  $monitor_class       = '',
  $monitor_options_hash = { },

  $firewall            = false,
  $firewall_options_hash = { },

  ) inherits elasticsearch::params {


  # Input parameters validation
  validate_re($ensure, ['present','absent'], 'Valid values are: present, absent. WARNING: If set to absent all the resources managed by the module are removed.')
  validate_re($install, ['package','upstream'], 'Valid values are: package, upstream.')
  validate_re($service_ensure, ['running','stopped'], 'Valid values are: running, stopped')
  validate_bool($service_enable)
  validate_bool($dir_recurse)
  validate_bool($dir_purge)
  if $file_options_hash { validate_hash($file_options_hash) }

  # Calculation of variables used in the module
  if $file_content {
    $managed_file_content = $file_content
  } else {
    if $file_template {
      $managed_file_content = template($file_template)
    } else {
      $managed_file_content = undef
    }
  }

  if $version {
    $managed_package_ensure = $version
  } else {
    $managed_package_ensure = $ensure
  }

  if $ensure == 'absent' {
    $managed_service_enable = undef
    $managed_service_ensure = stopped
    $dir_ensure = absent
    $file_ensure = absent
  } else {
    $managed_service_enable = $service_enable
    $managed_service_ensure = $service_ensure
    $dir_ensure = directory
    $file_ensure = present
  }

  $managed_install_source = $elasticsearch::install_source ? {
    ''      => "${elasticsearch::install_base_url}/elasticsearch-${elasticsearch::version}.zip",
    default => $elasticsearch::install_source,
  }

  $created_dir = url_parse($managed_install_source,'filedir')
  $home_dir = "${elasticsearch::install_destination}/${elasticsearch::created_dir}"

  $managed_file = $elasticsearch::install ? {
    package => $elasticsearch::file,
    default => "${elasticsearch::home_dir}/config/elasticsearch.yml",
  }

  $managed_dir = $elasticsearch::dir ? {
    ''      => $elasticsearch::install ? {
      package => $elasticsearch::dir,
      default => "${elasticsearch::home_dir}/config/",
    },
    default => $elasticsearch::dir,
  }

  $managed_service_provider = $install ? {
    /(?i:upstream|puppi)/ => 'init',
    default               => undef,
  }

  # Resources Managed
  class { 'elasticsearch::install':
  }

  class { 'elasticsearch::service':
    require => Class['elasticsearch::install'],
  }

  class { 'elasticsearch::config':
    require => Class['elasticsearch::install'],
  }


  # Extra classes
  if $elasticsearch::dependency_class {
    include $elasticsearch::dependency_class
  }

  if $elasticsearch::monitor_class {
    include $elasticsearch::monitor_class
  }

  if $elasticsearch::firewall_class {
    include $elasticsearch::firewall_class
  }

  if $elasticsearch::my_class {
    include $elasticsearch::my_class
  }

}
