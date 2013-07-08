#
# Testing configuration file provisioning via source
# Auditing enabled
#
class { 'elasticsearch':
  source => 'puppet:///modules/elasticsearch/tests/test.conf',
  audit  => 'all',
}
