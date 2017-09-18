class rt::vhost (
  $package,
  $package_maj_version,
  $rt_vhost_website,
  $rt_vhost_alias
) {

  if $rt::params::rt_manage_vhost == true {

    include apache::mod::alias
    include apache::mod::perl
    include apache::mod::proxy
    include apache::mod::proxy_html
    include apache::mod::proxy_balancer
    include apache::mod::headers
    include apache::mod::rewrite
    include apache::mod::ssl
    include apache::mod::wsgi

    cpan { "Plack::Handler::Apache2":
      ensure              => present,
      require             => Class['::cpan']
    }

    apache::vhost { "${rt_vhost_website}":
      port                => '80',
      serveraliases       => "${rt_vhost_alias}",
      docroot             => "/opt/${package}${package_maj_version}/share/html",
      add_default_charset => 'UTF-8',
      redirect_status     => 'permanent',
      redirect_dest       => "https://${rt_vhost_alias}",
      scriptalias         => "/ /opt/${package}${package_maj_version}/sbin/rt-server.fcgi/",
      custom_fragment     => "
    <Location />
      Require all granted

      SetHandler modperl
      PerlResponseHandler Plack::Handler::Apache2
      PerlSetVar psgi_app /opt/${package}${package_maj_version}/sbin/rt-server
    </Location>

    <Perl>
      use Plack::Handler::Apache2;
      Plack::Handler::Apache2->preload(\"/opt/${package}${package_maj_version}/sbin/rt-server\");
    </Perl>"
    }
  }
}