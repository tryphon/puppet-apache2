class apache2::auth::pam {

  package { libapache2-mod-auth-pam: }

  # README.Debian : add "www-data" user to "shadow" group
  users::in_group { www-data: 
    group => shadow,
    require => Package[libapache2-mod-auth-pam]
  }

}
