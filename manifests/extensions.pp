class rt::extensions (
  $package,
  $package_maj_version,
  $root_database_user,
  $root_database_password
) {

#######################################################################
#                                                                     #
# PLEASE NOTE.  Enabling extensions are done in rt::defaultsiteconfig #
#                                                                     #
#######################################################################

  # Requirements for any of the extension modules.
  $rt_extensions_list_deps = ["Set::Scalar",
                              "XML::Parser",
                              "XML::Simple"
                             ]
  $rt_extensions_list_deps.each |$extlsd| {
    cpan { $extlsd:
      ensure            => present,
      require           => Class['::cpan']
    }
  }

  # List of RT extensions to be installed
  $rt_extensions_list = { 'ext01' => { exturl => 'http://search.cpan.org/CPAN/authors/id/B/BP/BPS',
                                       extnam => 'RT-Extension-ActivityReports',
                                       extver => '1.08'
                                     },
                          'ext02' => { exturl => 'http://search.cpan.org/CPAN/authors/id/B/BP/BPS',
                                       extnam => 'RT-Extension-JSGantt',
                                       extver => '1.04'
                                     }
                        }

  # Assumes use of .tar.gz extension
  $rt_extensions_list.each |$key, $value| {
    $exturl = $value['exturl']
    $extnam = $value['extnam']
    $extver = $value['extver']

    exec { "${extnam}_download":
      path              => '/usr/local/bin/:/usr/bin/:/bin/',
      cwd               => '/usr/local/src',
      command           => "wget --quiet ${exturl}/${extnam}-${extver}.tar.gz --output-document=/usr/local/src/${extnam}-${extver}.tar.gz",
      creates           => "/usr/local/src/${extnam}-${extver}.tar.gz",
      notify            => Exec["${extnam}_extract"]
    }

    exec { "${extnam}_extract":
      path              => '/usr/local/bin/:/usr/bin/:/bin/',
      cwd               => '/usr/local/src',
      command           => "tar --gzip --extract --file=${extnam}-${extver}.tar.gz",
      creates           => "/usr/local/src/${extnam}-${extver}",
      subscribe         => Exec["${extnam}_download"],
      notify            => Exec["${extnam}_compile"]
    }

    exec { "${extnam}_compile":
      path              => '/usr/local/bin/:/usr/bin/:/bin/',
      cwd               => "/usr/local/src/${extnam}-${extver}",
      command           => "perl Makefile.PL && make && make install",
      creates           => "/opt/${package}${package_maj_version}/local/plugins/${extnam}",
      subscribe         => Exec["${extnam}_extract"]
    }
  }
}