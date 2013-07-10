#
# = Class: elasticsearch::install
#
# This class installs elasticsearch
#
class elasticsearch::install {

  case $elasticsearch::install {

    package: {

      if $elasticsearch::package {
        package { $elasticsearch::package:
          ensure   => $elasticsearch::managed_package_ensure,
          provider => $elasticsearch::package_provider,
        }
      }
    }

    upstream: {

      if $elasticsearch::user_create == true {
        require elasticsearch::user
      }
      # TODO: Use another define
      puppi::netinstall { 'netinstall_elasticsearch':
        url                 => $elasticsearch::managed_install_source,
        destination_dir     => $elasticsearch::install_destination,
        owner               => $elasticsearch::user,
        group               => $elasticsearch::user,
      }

      file { 'elasticsearch_link':
        ensure => "${elasticsearch::home_dir}" ,
        path   => "${elasticsearch::install_destination}/elasticsearch",
      }
    }

    puppi: {

      if $elasticsearch::bool_create_user == true {
        require elasticsearch::user
      }

      puppi::project::archive { 'elasticsearch':
        source      => $elasticsearch::managed_install_source,
        deploy_root => $elasticsearch::install_destination,
        user        => $elasticsearch::user,
        auto_deploy => true,
        enable      => true,
      }

      file { 'elasticsearch_link':
        ensure => "${elasticsearch::home_dir}" ,
        path   => "${elasticsearch::install_destination}/elasticsearch",
      }
    }

    default: { }

  }

}
