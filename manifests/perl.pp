class rt::perl (
  $package,
  $package_maj_version
) {

  # Dependencies for Perl modules.
  # Please put new packages in alpha order with the old ones or note why you didn't.
  $perl_dependencies = ["gd",
               "gd-devel",
               "gd",
               "openssl-devel",
               "perl-GD",
               "perl-GraphViz",
               "perl-DBD-MySQL"
              ]
  $perl_dependencies.each |$pkg| {
    package { $pkg:
      ensure    => present,
      before    => Package[$perl_modules_exec]
    }
  }

  # For some reason the cpan module above won't install these modules, so they need to be done manually.
  $perl_modules_exec = ["Encode",
                        "ExtUtils::MakeMaker",
                        "ExtUtils::PkgConfig",
                        "File::Which",
                        "GD",
                        "GD::Graph",
                        "GD::Text",
                        "GraphViz"
                       ]
  $perl_modules_exec.each |$plme| {
    exec { $plme:
      path      => '/usr/local/bin/:/usr/bin/:/bin/',
      command   => "cpan ${plme} && touch /usr/local/src/.${plme}_installed", # <--- Created file to verify that this is installed.
      creates   => "/usr/local/src/.${plme}_installed",
      before    => Package[$perl_modules_force]
    }
  }

  # Perl modules that need to be forced RT 4.4.2 requires to be install.
  # Please put new modules in alpha order with the old ones or note why you didn't.
  $perl_modules_force = ["Crypt::SSLeay",
                         "DBD::mysql",
                         "DBIx::SearchBuilder",
                         "List::MoreUtils",
                         "Net::SSL",
                         "Parallel::Prefork",
                         "XML::RSS"
                        ]
  $perl_modules_force.each |$plmf| {
    cpan { $plmf:
      ensure    => present,
      require   => Class['::cpan'],
      force     => true,
      before    => Package[$perl_modules]
    }
  }

  # Perl modules that RT 4.4.2 requires to be install.
  # Please put new modules in alpha order with the old ones or note why you didn't.
  $perl_modules = ["Apache::Session",
                   "Business::Hours",
                   "CGI",
                   "CGI::Cookie",
                   "CGI::Emulate::PSGI",
                   "CGI::PSGI",
                   "CSS::Minifier::XS",
                   "CSS::Squish",
                   "Class::Accessor::Fast",
                   "Class::Mix",
                   "Convert::Color",
                   "Crypt::Eksblowfish",
                   "Crypt::X509",
                   "Data::GUID",
                   "Data::ICal",
                   "Data::Page::Pageset",
                   "Date::Extract",
                   "Date::Manip",
                   "DateTime",
                   "DateTime::Format::Mail",
                   "DateTime::Format::Natural",
                   "DateTime::Format::W3CDTF",
                   "DateTime::Locale",
                   "Devel::GlobalDestruction",
                   "Devel::StackTrace",
                   "Digest::MD5",
                   "Digest::SHA",
                   "Digest::base",
                   "Email::Address",
                   "Email::Address::List",
                   "FCGI",
                   "File::ShareDir",
                   "GnuPG::Interface",
                   "HTML::Entities",
                   "HTML::FormatText::WithLinks",
                   "HTML::FormatText::WithLinks::AndTables",
                   "HTML::Mason",
                   "HTML::Mason::PSGIHandler",
                   "HTML::Quoted",
                   "HTML::RewriteAttributes",
                   "HTML::Scrubber",
                   "HTTP::Message",
                   "HTTP::Request::Common",
                   "IPC::Run",
                   "IPC::Run3",
                   "JSON",
                   "JavaScript::Minifier::XS",
                   "LWP",
                   "LWP::Protocol::https",
                   "LWP::Simple",
                   "LWP::UserAgent",
                   "Locale::Maketext",
                   "Locale::Maketext::Fuzzy",
                   "Locale::Maketext::Lexicon",
                   "Log::Dispatch",
                   "MIME::Entity",
                   "MIME::Types",
                   "Mail::Header",
                   "Mail::Mailer",
                   "Module::Refresh",
                   "Module::Versions::Report",
                   "Mozilla::CA",
                   "Net::CIDR",
                   "Net::IP",
                   "Net::LDAP",
                   "Net::SSLeay",
                   "PerlIO::eol",
                   "Plack",
                   "Plack::Handler::Starlet",
                   "Pod::Select",
                   "Regexp::Common",
                   "Regexp::Common::net::CIDR",
                   "Regexp::IPv6",
                   "Role::Basic",
                   "Scope::Upper",
                   "String::ShellQuote",
                   "Symbol::Global::Name",
                   "Sys::Syslog",
                   "Test::More",
                   "Text::Password::Pronounceable",
                   "Text::Quoted",
                   "Text::Template",
                   "Text::WikiFormat",
                   "Text::Wrapper",
                   "Time::ParseDate",
                   "Tree::Simple",
                   "UNIVERSAL::require",
                   "URI",
                   "URI::QueryParam"
	  			  ]
  $perl_modules.each |$plm| {
    cpan { $plm:
      ensure    => present,
      require   => Class['::cpan']
    }
  }
}
