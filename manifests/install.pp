# == Class: rt::install
#
#   Manages RT's installation
#
# === Parameters
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
# === Authors
#
# Anton Baranov <abaranov@linuxfoundation.org>
#
# === Copyright
#
# Copyright 2016 Anton Baranov
#
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
