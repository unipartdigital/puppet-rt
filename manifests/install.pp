class rt::install (
  $ensure,
  $package,
  $package_ensure,
) {
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

  package {$package:
    ensure => $_package_ensure
  }
}
