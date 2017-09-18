# == Class rt::params
#
#   Default definitions for other classes in that modules
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

  $ensure                           = 'present'
  $package                          = 'rt'
  $package_ensure                   = 'present'
  $package_version                  = '4.4.2'
  $package_maj_version              = '4'

  $user                             = 'root'
  $group                            = 'root'

  $web_user                         = 'apache'
  $web_group                        = 'apache'

  $rt_database_type                 = 'mysql'

  $root_database_user               = 'root'
  $root_database_password           = undef

  $rt_database_name                 = 'rt4'
  $rt_database_user                 = 'rtuser'
  $rt_database_password             = undef

  $rt_manage_vhost                  = true
  $rt_web_port                      = '443'
  $rt_vhost_website                 = 'example.com'
  $rt_vhost_alias                   = 'support.example.com'

  $rt_user                          = undef
  $rt_passwd                        = undef
  $rt_server                        = undef
  $rt_tool_cnf                      = "/opt/${package}${package_maj_version}/.rtrc"

  $config_dir                       = "/opt/${package}${package_maj_version}/etc"
  $config_site                      = "${config_dir}/RT_SiteConfig.pm"
  $config_d                         = "${config_dir}/RT_SiteConfig.d"

  if $::osfamily == 'RedHat' {
    $defaultsiteconfig    = {
      '$WebPort'           => "${rt_web_port}",
      '$DatabaseType'      => "${rt_database_type}",
    }
  }
}