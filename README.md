# Puppet module: elasticsearch

This is a Puppet module for elasticsearch.
It manages its installation, configuration and service.

The module is based on stdmod naming standars.
Refer to http://github.com/stdmod/

Released under the terms of Apache 2 License.


## USAGE - Basic management

* Install elasticsearch with default settings (package installed, service started, default configuration files)

        class { 'elasticsearch': }

* Remove elasticsearch package and purge all the managed files

        class { 'elasticsearch':
          ensure => absent,
        }

* Install a specific version of elasticsearch package

        class { 'elasticsearch':
          version => '1.0.1',
        }

* Install the latest version of elasticsearch package

        class { 'elasticsearch':
          version => 'latest',
        }

* Enable elasticsearch service. This is default.

        class { 'elasticsearch':
          service_ensure => 'running',
        }

* Enable elasticsearch service at boot. This is default.

        class { 'elasticsearch':
          service_status => 'enabled',
        }


* Do not automatically restart services when configuration files change (Default: Class['elasticsearch::config']).

        class { 'elasticsearch':
          service_subscribe => false,
        }

* Enable auditing (on all the arguments)  without making changes on existing elasticsearch configuration *files*

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
         my_class => 'site::elasticsearch_my',
        }

## TESTING
[![Build Status](https://travis-ci.org/stdmod/puppet-elasticsearch.png?branch=master)](https://travis-ci.org/stdmod/puppet-elasticsearch)
