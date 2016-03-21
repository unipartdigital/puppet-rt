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

  if $value {
    if $value.is_a(String) {
      validate_string($value)
    } elsif $value.is_a(Hash) {
      validate_hash($value)
    } elsif $value.is_a(Array) {
      validate_array($value)
    } else {
      fail('Value could be String, Hash or Array')
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

  $target_path = "${config_d}/${order}-${title}.pm"

  # Execs
  if $ensure == 'present' {
    exec { "${title} syntax check":
      path        => ['/bin', '/usr/bin'],
      command     => "perl -c ${target_path}",
      refreshonly => true,
    }
    File[$target_path] {
      notify  => Exec["${title} syntax check"]
    }
  }

  # Files and Directories
  file { $target_path:
    ensure  => $ensure,
    mode    => '0640',
    owner   => $web_user,
    group   => $web_group,
    content => template("${module_name}/RT_SiteConfig-fragment.pm.erb"),
  }


}
