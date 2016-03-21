# == Class: rt
#
#  Installs and configures RT (Request tracker:
#  https://www.bestpractical.com/rt/)
#
# === Parameters
#
#  [*siteconfig*]
#     A hash of RT's site confirutaion options. Check
#     https://docs.bestpractical.com/rt/4.4.0/RT_Config.html for available
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
#     Default: /etc/rt
#     
#  [*config_d*]
#     The absolute path to the directory where additional RT's configuration  
#     files are.
#
#     Type: String
#     Default: /etc/rt/RT_SiteConfig.d
#
#  [*config_site*]
#     The absolute path to the main RT's configuration file
#
#     Type: String
#     Default: /etc/rt/RT_SiteConfig.pm
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
# === Authors
#
# Anton Baranov <abaranov@linuxfoundation.org>
#
# === Copyright
#
# Copyright 2016 Anton Baranov
#
class rt (
  $siteconfig        = {},
  $ensure            = $rt::params::ensure,
  $package           = $rt::params::package,
  $package_ensure    = $rt::params::package_ensure,
  $config_dir        = $rt::params::config_dir,
  $config_d          = $rt::params::config_d,
  $config_site       = $rt::params::config_site,
  $user              = $rt::params::user,
  $group             = $rt::params::group,
  $web_user          = $rt::params::web_user,
  $web_group         = $rt::params::web_group,
  $defaultsiteconfig = $rt::params::defaultsiteconfig

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

  validate_hash(
    $defaultsiteconfig,
    $siteconfig
  )

  validate_string(
    $user,
    $group,
    $web_user,
    $web_group
  )

  anchor {'rt::begin':}
  anchor {'rt::end':}
  # Classes
  class {'rt::install':
    ensure         => $ensure,
    package        => $package,
    package_ensure => $_package_ensure,
  }

  class {'rt::config':
    ensure            => $ensure,
    config_dir        => $config_dir,
    config_d          => $config_d,
    config_site       => $config_site,
    user              => $user,
    group             => $group,
    web_user          => $web_user,
    web_group         => $web_group,
    siteconfig        => $siteconfig,
    defaultsiteconfig => $defaultsiteconfig
  }

  # Order and dependencies
  Anchor['rt::begin'] ->
  Class['rt::install'] ->
  Class['rt::config'] ->
  Anchor['rt::end']
}
