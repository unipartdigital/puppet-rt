# Puppet-RT [![Build Status](https://travis-ci.org/spacedog/puppet-rt.svg)](https://travis-ci.org/spacedog/puppet-rt)

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with puppet-rt](#setup)
    * [What puppet-rt affects](#what-rt-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with puppet-rt](#beginning-with-rt)
3. [Usage - Configuration options and additional functionality](#usage)
    * [Create a Request Tracker queue](#create-a-request-tracker-queue)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)

## Overview

This module manages source installation and configuration Request Tracker (RT)
installation and configuration

## Module Description

Module source installs and configures RT.

## Setup

### What puppet-rt affects

+ Module installs (including dependencies):
  * rt

  This can be overwritten using *_package_* parameter of *_rt_* class

+ Modules manages files:
  * /etc/rt/RT_SiteConfig.pm
  * /etc/rt/RT_SiteConfig.d/*.pm

### Setup Requirements

+ puppetlabs-stdlib
+ puppetlabs-mysql
+ puppetlabs-apache
+ puppet-mariadb
+ meltwater-cpan
+ example42-puppi

### Beginning with puppet-rt

For a basic  setup with a default configuration parameters it's just
enough to declare rt class inside the manifest
```puppet
include ::rt
```

## Usage

To pass any configuration parameters the *siteconfig* hash parameter is used.
*siteconfig* is merged with *defaultsiteconfig* from _params.pp_ and
pushed to /etc/rt/RT_SiteConfig.pm configuration file

*siteconfig* must be a hash that contains proper RT's configuration options:

```yaml
        rt::siteconfig:
                # Base configurations
                $rtname: 'example.com'
          $Organization: 'example'
            $OwnerEmail: 'root@example.com'
              $TimeZone: 'US/Pacific'
               # Web configurations
          $DatabaseType: 'mysql'
  $WebDefaultStylesheet: 'web2'
```

```puppet
include ::rt
```

The list of all options is available here: https://docs.bestpractical.com/rt/4.4.2/RT_Config.html

Configuration options can be managed using .pm files in /etc/rt/RT_SiteConfig.d
directory. This is implemented using _rt::siteconfig_ define.

```yaml
rt::siteconfigs:
         $rtname:
           value: 'example.com'
   $DatabaseType:
           value: 'mysql'
```

```puppet
$siteconfigs = hiera('rt::siteconfigs', {})
validate_hash($siteconfigs)
create_resources('rt::siteconfig', $siteconfigs)
```

To install the Request Tracker RT::Authen::ExternalAuth extension

```puppet
    class { "rt::ext::externalauth": }
```

To install Request Tracker mailgate

```puppet
    class { "rt::mailgate": }
```
    
### Create a Request Tracker queue

*!NOTICE!* Your RT *root* user's password will be exposed in your puppet manifest. Ensure
site.pp and or node configuration is properly secured so only puppet can read
it.

Configure the rt command line tool

```puppet
class { "rt::tool": 
    rt_user     => "root",
    rt_passwd   => "password",
    rt_server   => "http://rt.domain.com"
    }
```

Define your queue

```puppet
rt::queue { "queue1":
    description     => "RT queue 1",
    reply_email     => "rtq1@domain.com",
    comment_email   => "rtq1-comments@domain.com"
    }
```

## Reference

None

## Limitations

+ osfamily => RedHat

