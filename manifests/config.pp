#
# = Class: elasticsearch::config
#
# This class manages elasticsearch configurations
#
class elasticsearch::config {

  if $elasticsearch::file {
    file { 'elasticsearch.conf':
      ensure  => $elasticsearch::file_ensure,
      path    => $elasticsearch::managed_file,
      mode    => $elasticsearch::file_mode,
      owner   => $elasticsearch::file_owner,
      group   => $elasticsearch::file_group,
      source  => $elasticsearch::file_source,
      content => $elasticsearch::managed_file_content,
    }
  }

  # Configuration Directory, if dir defined
  if $elasticsearch::dir_source {
    file { 'elasticsearch.dir':
      ensure  => $elasticsearch::dir_ensure,
      path    => $elasticsearch::managed_dir,
      source  => $elasticsearch::dir_source,
      recurse => $elasticsearch::dir_recurse,
      purge   => $elasticsearch::dir_purge,
      force   => $elasticsearch::dir_purge,
    }
  }

}
