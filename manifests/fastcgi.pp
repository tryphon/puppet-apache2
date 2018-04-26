class apache2::fastcgi {
  package { 'libapache2-mod-fastcgi': }
  apache2::module { 'fastcgi':
    require => Package['libapache2-mod-fastcgi']
  }
}
