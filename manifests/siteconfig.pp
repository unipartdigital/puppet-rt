define rt::siteconfig (
  $value  = undef,
  $ensure = 'present',
  $order  = '99',
) {

  include ::rt::params
  # Valitaion
  validate_re($ensure, [
    '^absent$',
    '^present$'
  ])
  validate_string(
    $order
  )

  # Variables
  $config_d  = hiera('rt::config_d',  $rt::params::config_d)
  validate_absolute_path($config_d)

  $web_user  = hiera('rt::web_user',  $rt::params::web_user)
  $web_group = hiera('rt::web_group', $rt::params::web_group)
  validate_string(
    $web_user,
    $web_group
  )

  $target_path = "${config_d}/${order}-${title}.pm"

  # Files and Directories
  file { $target_path:
    ensure  => $ensure,
    mode    => '0640',
    owner   => $web_user,
    group   => $web_group,
    content => template("${module_name}/RT_SiteConfig-fragment.pm.erb"),
    notify  => Exec["${target_path} syntax check"]
  }

  # Execs
  exec { "${target_path} syntax check":
    path        => ['/bin', '/usr/bin'],
    command     => "perl -c ${target_path}",
    refreshonly => true,
  }

}
