# == Class: rt
#
#  Installs and configures RT (Request tracker:
#  https://www.bestpractical.com/rt/)
#
# === Parameters
#
#  [*siteconfig*]
#     A hash of RT's site confirutaion options. Check
#     https://docs.bestpractical.com/rt/4.4.2/RT_Config.html for available
#     configurtion options. This hash is merged with defaultsiteconfig (check
#     below) and the result of  the merge is push to RT's siteconfig file 
#     defined by config_site parameter
#
#     Type: Hash
#     Default: {}
#
#  [*ensure*]
#     Global ensure for all resources in module
#
#     Type: String
#     Available values: 'present', 'absent'
#     Default: present
#
#  [*package*]
#     The name of package(s) that provides RT
#
#     Type: String or Array
#     Default: rt
#
#  [*package_ensure*]
#     The state of RT package. If ensure paramter is present then 'present',
#     'installed', 'absent', 'purged', 'held', 'latest' should be used for
#     package_ensure.
#    
#     Type: String
#     Available values:'present', 'installed', 'absent', 'purged', 'held',
#                     'latest' 
#     Default: present
#
#  [*config_dir*]
#     The absolute path to the directory where RT's configuration  files are.
#     
#     Type: String
#     Default: /opt/rt4
#     
#  [*config_d*]
#     The absolute path to the directory where additional RT's configuration  
#     files are.
#
#     Type: String
#     Default: /opt/rt4/RT_SiteConfig.d
#
#  [*config_site*]
#     The absolute path to the main RT's configuration file
#
#     Type: String
#     Default: /opt/rt4/RT_SiteConfig.pm
#
#  [*user*]
#     The owner of config_dir directory
#
#     Type: String
#     Default: root
#
#  [*group*]
#     The group for config_dir directory 
#
#     Type: String
#     Default: root
#
#  [*web_user*]
#     The web user name to read RT's site configuration files
#
#     Type: String
#     Default: apache
#
#  [*web_group*]
#     The web group name to read RT's site configuration files
#
#     Type: String
#     Default: apache
#
#  [*defaultsiteconfig*]
#     The default site configuration hash. This hash is mergerd with siteconfig
#     hash and used to prepare RT's site configuration file
#     
#     Type: Hash
#     Default: check rt::params class
#
#  [*rt_web_port*]
#     The web port user
#
#     Type: String
#     Default: 443
#
#  [*rt_database_type*]
#     Valid types are "mysql", "Oracle", and "Pg"
#
#     Type: String
#     Default: mysql
#
#  [*package_version*]
#     Version of RT to install
#
#     Type: String
#     Default: 4.4.2
#
#  [*package_maj_version*]
#     Major version number of RT to install
#
#     Type: String
#     Default: 4
#
#  [*root_database_user*]
#     The database root user
#
#     Type: String
#     Default: root
#
#  [*root_database_password*]
#     The database root password
#
#     Type: String
#     Default: undef
#
#  [*rt_database_name*]
#     The RT database name password
#
#     Type: String
#     Default: rt4
#
#  [*rt_database_user*]
#     The RT database user
#
#     Type: String
#     Default: rtuser
#
#  [*rt_database_password*]
#     The RT database user password
#
#     Type: String
#     Default: undef
#
#  [*rt_manage_vhost*]
#     Manage RT virtual host record
#     Valid types true and false
#
#     Type: boolean
#     Default: true
#
#  [*rt_vhost_website*]
#     The RT domain name
#
#     Type: String
#     Default: example.com
#
#  [*rt_vhost_alias*]
#     The RT domain name alias
#
#     Type: String
#     Default: support.example.com
#
#  [*rt_tool_cnf*]
#     Add queue(s) to RT
#
#     Type: String
#     Default: /opt/rt4/.rtrc
#
#
# === Authors
#
# Anton Baranov <abaranov@linuxfoundation.org>
#
# === Copyright
#
# Copyright 2016 Anton Baranov
#
class rt (
  $siteconfig              = {},
  $ensure                  = $rt::params::ensure,
  $package                 = $rt::params::package,
  $package_ensure          = $rt::params::package_ensure,
  $package_version         = $rt::params::package_version,
  $package_maj_version     = $rt::params::package_maj_version,
  $config_dir              = $rt::params::config_dir,
  $config_d                = $rt::params::config_d,
  $config_site             = $rt::params::config_site,
  $user                    = $rt::params::user,
  $group                   = $rt::params::group,
  $web_user                = $rt::params::web_user,
  $web_group               = $rt::params::web_group,
  $defaultsiteconfig       = $rt::params::defaultsiteconfig,
  $rt_web_port             = $rt::params::rt_web_port,
  $rt_database_type        = $rt::params::rt_database_type,
  $root_database_user      = $rt::params::root_database_user,
  $root_database_password  = $rt::params::root_database_password,
  $rt_database_name        = $rt::params::rt_database_name,
  $rt_database_user        = $rt::params::rt_database_user,
  $rt_database_password    = $rt::params::rt_database_password,
  $rt_manage_vhost         = $rt::params::rt_manage_vhost,
  $rt_vhost_website        = $rt::params::rt_vhost_website,
  $rt_vhost_alias          = $rt::params::rt_vhost_alias,
  $rt_user                 = $rt::params::rt_user,
  $rt_passwd               = $rt::params::rt_passwd,
  $rt_server               = $rt::params::rt_server,
  $rt_tool_cnf             = $rt::params::rt_tool_cnf


) inherits rt::params {

  # Parameters validation
  validate_re($ensure, [
    '^present',
    '^absent'
  ])
  if is_array($package) {
    validate_array($package)
  } else {
    validate_string($package)
  }
  if $ensure == 'absent' {
    $_package_ensure = 'absent'
  } else {
    validate_re($package_ensure,[
      '^present$',
      '^installed$',
      '^absent$',
      '^purged$',
      '^held$',
      '^latest$',
      ])
    $_package_ensure = $package_ensure
  }

  validate_absolute_path(
    $config_dir,
    $config_site
  )

  validate_bool(
    $rt_manage_vhost
  )

  validate_hash(
    $defaultsiteconfig,
    $siteconfig
  )

  validate_string(
    $user,
    $group,
    $web_user,
    $web_group,
    $rt_web_port,
    $rt_database_type,
    $root_database_user,
    $root_database_password,
    $rt_database_name,
    $rt_database_user,
    $rt_database_password,
    $rt_vhost_website,
    $rt_vhost_alias,
    $rt_user,
    $rt_passwd,
    $rt_server,
    $rt_tool_cnf

  )

  anchor {'rt::begin':}
  anchor {'rt::end':}

  # Classes
  class {'rt::perl':
    package                => $package,
    package_maj_version    => $package_maj_version
  }

  class {'rt::install':
    package                => $package,
    package_version        => $package_version,
    package_maj_version    => $package_maj_version,
    root_database_user     => $root_database_user,
    root_database_password => $root_database_password,
    rt_database_user       => $rt_database_user,
    rt_database_password   => $rt_database_password
  }

  class {'rt::selinux':
    package                => $package,
    package_maj_version    => $package_maj_version,
    rt_rtname              => $rt_rtname,
    rt_organization        => $rt_organization,
    rt_web_port            => $rt_web_port
  }

  class {'rt::extensions':
    package                => $package,
    package_maj_version    => $package_maj_version,
    root_database_user     => $root_database_user,
    root_database_password => $root_database_password
  }

  class {'rt::vhost':
    package                => $package,
    package_maj_version    => $package_maj_version,
    rt_vhost_website       => $rt_vhost_website,
    rt_vhost_alias         => $rt_vhost_alias
  }

  class {'rt::config':
    ensure                 => $ensure,
    config_dir             => $config_dir,
    config_d               => $config_d,
    config_site            => $config_site,
    user                   => $user,
    group                  => $group,
    web_user               => $web_user,
    web_group              => $web_group,
    siteconfig             => $siteconfig,
    defaultsiteconfig      => $defaultsiteconfig
  }

  class {'rt::tool':
    rt_user                => $rt_user,
    rt_passwd              => $rt_passwd,
    rt_server              => $rt_server
  }

  class {'rt::path':
    package                => $package,
    package_maj_version    => $package_maj_version
  }

  # Order and dependencies
  Anchor['rt::begin']      ->
  Class['rt::perl']        ->
  Class['rt::install']     ->
  Class['rt::selinux']     ->
  Class['rt::extensions']  ->
  Class['rt::vhost']       ->
  Class['rt::config']      ->
  Class['rt::tool']        ->
  Class['rt::path']        ->
  Anchor['rt::end']
}
