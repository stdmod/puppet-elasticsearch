#
# = Class: elasticsearch::install
#
# This class installs elasticsearch
#
class elasticsearch::install {

  if $elasticsearch::package {
    package { $elasticsearch::package:
      ensure   => $elasticsearch::managed_package_ensure,
      provider => $elasticsearch::package_provider,
      noop     => $elasticsearch::noop,
    }
  }

}
