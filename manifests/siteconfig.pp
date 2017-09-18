# == Define rt::siteconfig
#
#   Defines additional site config options using files in conf.d
#
# === Parameters
#
#   [*ensure*]
#     State of configuration option
#
#     Type: String
#     Available values: 'present', 'absent'
#
#   [*value*]
#     The value for the configuration option:
#
#     Type: String, Hash or Array
#     Default: undef
#
# === Authors
#
# Anton Baranov <abaranov@linuxfoundation.org>
#
# === Copyright
#
# Copyright 2016 Anton Baranov
#
define rt::siteconfig (
  $value  = undef,
  $ensure = 'present'
) {

  include ::rt::params
  # Validation
  validate_re($ensure, [
    '^absent$',
    '^present$'
  ])

  if $value {
    if is_hash($value) {
      validate_hash($value)
    } elsif is_array($value) {
      validate_array($value)
    } else {
      validate_string($value)
    }
  }  else {
    fail("Value must be defined for ${title}")
  }

  # Variables
  $config_d  = hiera('rt::config_d',  $rt::params::config_d)
  validate_absolute_path($config_d)

  $web_user  = hiera('rt::web_user',  $rt::params::web_user)
  $web_group = hiera('rt::web_group', $rt::params::web_group)
  validate_string(
    $web_user,
    $web_group
  )

  $target_path = "${config_d}/${title}.pm"

  # Execs
  if $ensure == 'present' {
    exec { "${title} syntax check":
      path        => ['/bin', '/usr/bin'],
      command     => "perl -c ${target_path}",
      refreshonly => true
    }
    File[$target_path] {
      notify      => Exec["${title} syntax check"]
    }
  }

  # Files and Directories
  file { $target_path:
    ensure        => $ensure,
    mode          => '0640',
    owner         => $web_user,
    group         => $web_group,
    content       => template("${module_name}/RT_SiteConfig-fragment.pm.erb")
  }
}