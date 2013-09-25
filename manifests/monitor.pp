#
# = Class: elasticsearch::monitor
#
# This class monitors elasticsearch
#
# POC
#
class elasticsearch::monitor {

  $enable   = $elasticsearch::monitor_options_hash['enable'],
  $tool     = $elasticsearch::monitor_options_hash['tool'],
  $host     = $elasticsearch::monitor_options_hash['host'],
  $protocol = $elasticsearch::monitor_options_hash['protocol'],
  $port     = $elasticsearch::monitor_options_hash['port'],
  $service  = $elasticsearch::monitor_options_hash['service'],
  $process  = $elasticsearch::monitor_options_hash['process'],

  if $port and $protocol == 'tcp' {
    monitor::port { "elasticsearch_port_${protocol}_${port}":
      enable   => $enable,
      tool     => $tool,
      ip       => $host,
      protocol => $protocol,
      port     => $port,
    }
  }
  if $service {
    monitor::service { "elasticsearch_service_${service}":
      enable   => $enable,
      tool     => $tool,
      service  => $service,
    }
  }


}
