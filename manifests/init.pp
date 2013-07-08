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

  $package             = $elasticsearch::params::package,
  $package_provider    = undef,

  $service             = $elasticsearch::params::service,
  $service_ensure      = 'running',
  $service_enable      = true,
  $service_subscribe   = $elasticsearch::params::service_subscribe,
  $service_provider    = undef,

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

  $dependency_class    = undef,
  $monitor_class       = 'elasticsearch::monitor',
  $firewall_class      = 'elasticsearch::firewall',
  $my_class            = undef,

  $monitor             = false,
  $monitor_host        = $::ipaddress,
  $monitor_port        = 22,
  $monitor_protocol    = tcp,
  $monitor_tool        = '',

  $firewall            = false,
  $firewall_src        = '0/0',
  $firewall_dst        = '0/0',
  $firewall_port       = 22,
  $firewall_protocol   = tcp

  ) inherits elasticsearch::params {


  # Input parameters validation
  validate_re($ensure, ['present','absent'], 'Valid values are: present, absent. WARNING: If set to absent all the resources managed by the module are removed.')
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

  if $elasticsearch::monitor and $elasticsearch::monitor_class {
    include $elasticsearch::monitor_class
  }

  if $elasticsearch::firewall and $elasticsearch::firewall_class {
    include $elasticsearch::firewall_class
  }

  if $elasticsearch::my_class {
    include $elasticsearch::my_class
  }

}
