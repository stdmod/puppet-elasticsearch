#
# = Class: elasticsearch::config
#
# This class manages elasticsearch configurations
#
class elasticsearch::config {

  if $elasticsearch::file {
    file { 'elasticsearch.conf':
      ensure  => $elasticsearch::file_ensure,
      path    => $elasticsearch::file,
      mode    => $elasticsearch::file_mode,
      owner   => $elasticsearch::file_owner,
      group   => $elasticsearch::file_group,
      source  => $elasticsearch::file_source,
      content => $elasticsearch::managed_file_content,
      audit   => $elasticsearch::audit,
      noop    => $elasticsearch::noop,
    }
  }

  # Configuration Directory, if dir defined
  if $elasticsearch::dir_source {
    file { 'elasticsearch.dir':
      ensure  => $elasticsearch::dir_ensure,
      path    => $elasticsearch::dir,
      source  => $elasticsearch::dir_source,
      recurse => $elasticsearch::dir_recurse,
      purge   => $elasticsearch::dir_purge,
      force   => $elasticsearch::dir_purge,
      audit   => $elasticsearch::audit,
      noop    => $elasticsearch::noop,
    }
  }

}
