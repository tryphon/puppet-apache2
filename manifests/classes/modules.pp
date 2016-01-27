class apache2::auth::pam {

  package { libapache2-mod-auth-pam: }

  # README.Debian : add "www-data" user to "shadow" group
  users::in_group { www-data:
    group => shadow,
    require => Package[libapache2-mod-auth-pam]
  }

}

class apache2::rewrite {
  apache2::module { rewrite: }
}

class apache2::headers {
  apache2::module { headers: }
}

class apache2::deflate {
  include apache2::headers
  apache2::module { deflate: }
  confd_file { deflate:
    require => [Apache2::Module[deflate], Apache2::Module[headers]]
  }
}

class apache2::expires {
  apache2::module { expires: }
}

class apache2::xsendfile {
  package { libapache2-mod-xsendfile:
    require => Package[apache2]
  }

  if $debian::lenny {
    apt::preferences { libapache2-mod-xsendfile:
      package => libapache2-mod-xsendfile,
      pin => "release a=lenny-backports",
      priority => 999,
      before => Package[libapache2-mod-xsendfile]
    }
  }

  apache2::module { xsendfile: }
}

class apache2::ssl {
  apache2::module { ssl: }

  file { "/etc/apache2/ssl_params.conf":
    source => "puppet:///apache2/ssl_params.conf"
  }
}

class apache2::fastcgi {
  package { 'libapache2-mod-fastcgi': }
  apache2::module { 'fastcgi':
    require => Package['libapache2-mod-fastcgi']
  }
}
