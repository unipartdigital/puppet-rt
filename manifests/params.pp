# == Class rt::params
#
#   Default definitions for other classes in that modules

# === Parameters
#
#   None
#
# === Authors
#
# Anton Baranov <abaranov@linuxfoundation.org>
#
# === Copyright
#
# Copyright 2016 Anton Baranov
#
class rt::params {
  $ensure            = 'present'
  $package           = 'rt'
  $package_ensure    = 'present'

  $user              = 'root'
  $group             = 'root'

  $web_user          = 'apache'
  $web_group         = 'apache'

  $config_dir        = '/etc/rt'
  $config_site       = "${config_dir}/RT_SiteConfig.pm"
  $config_d          = "${config_dir}/RT_SiteConfig.d"

  if $::osfamily == 'RedHat' {
    $defaultsiteconfig = {
      'rtname'  => 'example.com',
      'WebPath' => '/rt'
    }
  }

}
