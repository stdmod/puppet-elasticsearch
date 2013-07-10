#
# = Class: elasticsearch::service
#
# This class manages elasticsearch service
#
class elasticsearch::service {

  if $elasticsearch::service {
    service { $elasticsearch::service:
      ensure     => $elasticsearch::managed_service_ensure,
      enable     => $elasticsearch::managed_service_enable,
      subscribe  => $elasticsearch::service_subscribe,
      provider   => $elasticsearch::managed_service_provider,
    }
  }

}
