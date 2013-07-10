# Class: elasticsearch::dependency
#
# This class installs elasticsearch dependency
#
# == Usage
#
# This class may contain resources available on the
# Example42 modules set.
#
class elasticsearch::dependency {

  include java

  if $elasticsearch::install != 'package' {
    git::reposync { 'elasticsearch-servicewrapper':
      source_url      => 'https://github.com/elasticsearch/elasticsearch-servicewrapper.git',
      destination_dir => "${elasticsearch::install_destination}/elasticsearch-servicewrapper",
      post_command    => "cp -a ${elasticsearch::install_destination}/elasticsearch-servicewrapper/service/ ${elasticsearch::home_dir}/bin ; chown -R ${elasticsearch::user}:${elasticsearch::user} ${elasticsearch::home_dir}/bin/service",
      creates         => "${elasticsearch::home_dir}/bin/service",
      before          => [ Class['elasticsearch::service'] , Class['elasticsearch::config'] ],
    }
    exec { 'elasticsearch-servicewrapper-copy':
      command => "cp -a ${elasticsearch::install_destination}/elasticsearch-servicewrapper/service/ ${elasticsearch::home_dir}/bin ; chown -R ${elasticsearch::user}:${elasticsearch::user} ${elasticsearch::home_dir}/bin/service",
      path    => '/bin:/sbin:/usr/sbin:/usr/bin',
      creates => "${elasticsearch::home_dir}/bin/service",
      require => Git::Reposync['elasticsearch-servicewrapper'],
    }
    file { "${elasticsearch::home_dir}/bin/service/elasticsearch":
      ensure  => present,
      mode    => 0755,
      owner   => $elasticsearch::user,
      group   => $elasticsearch::user,
      content => template($elasticsearch::init_script_file_template),
      before  => Class['elasticsearch::service'],
      require => Git::Reposync['elasticsearch-servicewrapper'],
    }
    file { "/etc/init.d/elasticsearch":
      ensure  => "${elasticsearch::home_dir}/bin/service/elasticsearch",
    }
    file { "${elasticsearch::home_dir}/bin/service/elasticsearch.conf":
      ensure  => present,
      mode    => 0644,
      owner   => $elasticsearch::user,
      group   => $elasticsearch::user,
      content => template($elasticsearch::init_options_file_template),
      before  => Class['elasticsearch::service'],
      require => Git::Reposync['elasticsearch-servicewrapper'],
    }
    file { "${elasticsearch::home_dir}/logs":
      ensure  => directory,
      mode    => 0755,
      owner   => $elasticsearch::user,
      group   => $elasticsearch::user,
      before  => Class['elasticsearch::service'],
      require => Git::Reposync['elasticsearch-servicewrapper'],
    }
  }

}
