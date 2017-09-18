class rt::selinux (
  $package,
  $package_maj_version,
  $rt_rtname,
  $rt_organization,
  $rt_web_port
) {

  # Set SELinux Booleans.
  if $::selinux {
    $selboolean = ["httpd_can_sendmail",
                   "httpd_unified"
                  ]
    $selboolean.each |$selb| {
      selboolean { $selb:
        name       => "$selb",
        persistent => true,
        value      => on
      }
    }
    exec { 'rt_chcon':
      path         => '/usr/local/bin/:/usr/bin/:/bin/',
      command      => "chcon --recursive user_u:object_r:httpd_user_content_t:s0 /opt/${package}${package_maj_version}/var",
      onlyif       => "stat --format='%C' /opt/rt4/var | grep --invert-match 'user_u:object_r:httpd_user_content_t:s0'"
    }
  }
}