class rt::path (
  $package_maj_version,
  $package
) {

  file { '/etc/profile.d/rt.sh':
    mode    => '644',
    content => "PATH=\$PATH:/opt/${package}${package_maj_version}/bin:/opt/${package}${package_maj_version}/sbin"
  }

  file { '/etc/profile.d/rt.csh':
    mode    => '644',
    content => "setenv PATH \$PATH\:/opt/${package}${package_maj_version}/bin\:/opt/${package}${package_maj_version}/sbin"
  }
}