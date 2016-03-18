# Class: rt
# ===========================
#
# Full description of class rt here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'rt':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
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

  # Calling other classes
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
  Class['rt::install'] -> Class['rt::config']
}
