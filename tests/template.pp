#
# Testing configuration file provisioning via template
# Auditing enabled
#
class { 'elasticsearch':
  template => 'elasticsearch/tests/test.conf',
  audit    => 'all',
}
