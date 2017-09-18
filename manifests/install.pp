# == Class: rt::install
#
#   Manages RT's source installation
#
# === Parameters
#
#  [*package*]
#     The name of package(s) that provides RT
#
#     Type: String or Array
#     Default: rt
#
#  [*package_version*]
#     Version of RT to install
#
#     Type: String
#     Default: 4.4.2
#
#  [*package_maj_version*]
#     Version of RT to install
#
#     Type: String
#     Default: 4
#
#  [*root_database_user*]
#     Database root user
#
#     Type: String
#     Default: root
#
#  [*rt_database_user*]
#     RT database user
#
#     Type: String
#     Default: check rt::params class
#
#  [*rt_database_password*]
#     RT database password
#
#     Type: String
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
class rt::install (

  $package,
  $package_version,
  $package_maj_version,
  $root_database_user,
  $root_database_password,
  $rt_database_user,
  $rt_database_password
) {

  puppi::netinstall { 'rt_source':
    url                 => "https://download.bestpractical.com/pub/rt/release/${package}-${package_version}.tar.gz",
    work_dir            => '/usr/local/src',
    destination_dir     => '/usr/local/src',
    postextract_command => "/usr/local/src/${package}-${package_version}/configure --with-db-type=mysql --with-externalauth --enable-graphviz --enable-gd --with-web-user=apache --with-web-group=apache --with-web-handler=modperl2 --with-db-rt-user=${rt::rt_database_user} --with-db-rt-pass=${rt::rt_database_password} && make install && /opt/${package}${package_maj_version}/sbin/rt-setup-database --action init --dba ${rt::root_database_user} --dba-password ${rt::root_database_password}"
  }
}
