#
# = Class: elasticsearch::monitor
#
# This class monitors elasticsearch
#
class elasticsearch::monitor (
  $enable   = $elasticsearch::monitor,
  $tool     = $elasticsearch::monitor_tool,
  $host     = $elasticsearch::monitor_host,
  $protocol = $elasticsearch::monitor_protocol,
  $port     = $elasticsearch::monitor_port,
  $service  = $elasticsearch::service,
  ) inherits elasticsearch {

  if $port and $protocol == 'tcp' {
    monitor::port { "elasticsearch_${elasticsearch::protocol}_${elasticsearch::port}":
      ip       => $host,
      protocol => $protocol,
      port     => $port,
      tool     => $tool,
      enable   => $enable,
    }
  }
  if $service {
    monitor::service { 'elasticsearch_service':
      service  => $service,
      tool     => $tool,
      enable   => $enable,
    }
  }
}
