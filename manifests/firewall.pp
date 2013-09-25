#
# = Class: elasticsearch::firewall
#
# This class firewalls elasticsearch
#
# POC
#
class elasticsearch::firewall {

  $enable          = $elasticsearch::firewall_options_hash['enable'],
  $tool            = $elasticsearch::firewall_options_hash['tool'],
  $host            = $elasticsearch::firewall_options_hash['host'],
  $port            = $elasticsearch::firewall_options_hash['port'],
  $protocol        = $elasticsearch::firewall_options_hash['protocol'],
  $source_ip4      = $elasticsearch::firewall_options_hash['source_ip4'],
  $destination_ip4 = $elasticsearch::firewall_options_hash['destination_ip4'],
  $source_ip6      = $elasticsearch::firewall_options_hash['source_ip6'],
  $destination_ip6 = $elasticsearch::firewall_options_hash['destination_ip6'],

  if $port {
    firewall::port { "elasticsearch_${protocol}_${port}":
      enable   => $enable,
      ip       => $host,
      protocol => $protocol,
      port     => $port,
      tool     => $tool,
    }
  }
}
