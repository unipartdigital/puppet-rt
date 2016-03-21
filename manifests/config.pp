# == Class: rt::config
#
#   Manages RT's configuration files
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
class rt::config (
  $ensure,
  $config_dir,
  $config_site,
  $config_d,
  $user,
  $group,
  $web_user,
  $web_group,
  $siteconfig,
  $defaultsiteconfig,
){
  # Validation
  validate_re($ensure, [
    '^present',
    '^absent'
  ])
  validate_absolute_path(
    $config_dir,
    $config_d,
    $config_site
  )
  validate_hash(
    $siteconfig,
    $defaultsiteconfig
  )
  validate_string(
    $user,
    $group,
    $web_user,
    $web_group
  )

  $dir_ensure = $ensure ? {
    'present' => 'directory',
    default   => 'absent'
  }

  # Files and Directories
  file { $config_dir:
    ensure => $dir_ensure,
    mode   => '0755',
    owner  => $user,
    group  => $group,
  }

  file { $config_d:
    ensure => $dir_ensure,
    mode   => '0640',
    owner  => $web_user,
    group  => $web_group,
  }

  # Configuration options
  $mergedsiteconfig = merge($defaultsiteconfig, $siteconfig)


  if $ensure == 'present' {
    exec {'Site config syntax check':
      path        => ['/bin', '/usr/bin'],
      command     => "perl -c ${config_site}",
      refreshonly => true,
    }
    File[$config_site]{
      notify  => Exec['Site config syntax check'],
    }
  }

  file { $config_site:
    ensure  => $ensure,
    mode    => '0640',
    owner   => $web_user,
    group   => $web_group,
    content => template("${module_name}/RT_SiteConfig.pm.erb"),
  }


}
