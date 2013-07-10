# Puppet module: elasticsearch

This is a Puppet module for elasticsearch.
It manages its installation, configuration and service.

The module is based on stdmod naming standars.
Refer to http://github.com/stdmod/

Released under the terms of Apache 2 License.

NOTE: This module is to be considered a POC, that uses the stdmod naming conventions.
For development time reasons the module currently uses some Example42 modules and prerequisites.

## USAGE - Basic management

* Install elasticsearch with default package, settings and dependencies

        class { 'elasticsearch': }

* Install elasticsearch fetching the upstream tarball

        class { 'elasticsearch':
          install => 'upstream',
          version => '0.90.2',
        }

* Remove elasticsearch package and purge all the managed files

        class { 'elasticsearch':
          ensure => absent,
        }

* Create an elasticsearch user with defined settings

        class { 'elasticsearch':
          install     => 'upstream',
          user_create => true, # Default
          user_uid    => '899',
        }

* Do not create an elasticsearch user when installing via upstream
  (You must provide it in othr ways)

        class { 'elasticsearch':
          install     => 'upstream',
          user_create => false,
        }

* Manage Java settings

        class { 'elasticsearch':
          java_heap_size => '2048', # Default: 1024
        }

* Specify a custom template to use for the init script and its path

        class { 'elasticsearch':
          init_script_file           = '/etc/init.d/elasticsearch', # Default
          init_script_file_template  = 'site/elasticsearch/init.erb',
        }

* Provide a custom configuration file for the init script (here you can better tune Java settings)

        class { 'elasticsearch':
          init_options_file_template  = 'site/elasticsearch/init_options.erb',
        }


* Do not automatically restart services when configuration files change (Default: Class['elasticsearch::config']).

        class { 'elasticsearch':
          service_subscribe => false,
        }

* Enable auditing (on all the arguments)

        class { 'elasticsearch':
          audit => 'all',
        }

* Module dry-run: Do not make any change on *all* the resources provided by the module

        class { 'elasticsearch':
          noop => true,
        }


## USAGE - Overrides and Customizations
* Use custom source for main configuration file

        class { 'elasticsearch':
          file_source => [ "puppet:///modules/example42/elasticsearch/elasticsearch.conf-${hostname}" ,
                           "puppet:///modules/example42/elasticsearch/elasticsearch.conf" ],
        }


* Use custom source directory for the whole configuration dir.

        class { 'elasticsearch':
          dir_source  => 'puppet:///modules/example42/elasticsearch/conf/',
        }

* Use custom source directory for the whole configuration dir purging all the local files that are not on the dir.
  Note: This option can be used to be sure that the content of a directory is exactly the same you expect, but it is desctructive and may remove files.

        class { 'elasticsearch':
          dir_source => 'puppet:///modules/example42/elasticsearch/conf/',
          dir_purge  => true, # Default: false.
        }

* Use custom source directory for the whole configuration dir and define recursing policy.

        class { 'elasticsearch':
          dir_source    => 'puppet:///modules/example42/elasticsearch/conf/',
          dir_recursion => false, # Default: true.
        }

* Use custom template for main config file. Note that template and source arguments are alternative.

        class { 'elasticsearch':
          file_template => 'example42/elasticsearch/elasticsearch.conf.erb',
        }

* Use a custom template and provide an hash of custom configurations that you can use inside the template

        class { 'elasticsearch':
          filetemplate       => 'example42/elasticsearch/elasticsearch.conf.erb',
          file_options_hash  => {
            opt  => 'value',
            opt2 => 'value2',
          },
        }


* Specify the name of a custom class to include that provides the dependencies required by the module

        class { 'elasticsearch':
          dependency_class => 'site::elasticsearch_dependency',
        }


* Automatically include a custom class with extra resources related to elasticsearch.
  Here is loaded $modulepath/example42/manifests/my_elasticsearch.pp.
  Note: Use a subclass name different than elasticsearch to avoid order loading issues.

        class { 'elasticsearch':
          my_class => 'site::my_elasticsearch',
        }

* Specify an alternative class where elasticsearch monitoring is managed

        class { 'elasticsearch':
          monitor_class => 'site::monitor::elasticsearch',
        }

* Enable and configure monitoring (with default elasticsearch::monitor)

        class { 'elasticsearch':
          monitor             = true,                  # Default: false
          monitor_host        = $::ipaddress_eth0,     # Default: $::ipaddress
          monitor_port        = 9200,                  # Default
          monitor_tool        = [ 'nagios' , 'monit' ] # Default: ''
        }

* Enable and configure firewalling (with default elasticsearch::firewall)

        class { 'elasticsearch':
          firewall             = true,                  # Default: false
          firewall_src         = '10.0.0.0/24,          # Default: 0/0
          firewall_dst         = $::ipaddress_eth0,     # Default: 0/0
          firewall_port        = 9200,                  # Default
        }


## TESTING
[![Build Status](https://travis-ci.org/stdmod/puppet-elasticsearch.png?branch=master)](https://travis-ci.org/stdmod/puppet-elasticsearch)
