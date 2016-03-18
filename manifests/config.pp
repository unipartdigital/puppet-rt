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

  exec {'Site config syntax check':
    path        => ['/bin', '/usr/bin'],
    command     => "perl -c ${config_site}",
    refreshonly => true,
  }
  file { $config_site:
    ensure  => $ensure,
    mode    => '0640',
    owner   => $web_user,
    group   => $web_group,
    content => template("${module_name}/RT_SiteConfig.pm.erb"),
    notify  => Exec['Site config syntax check'],
  }

}
