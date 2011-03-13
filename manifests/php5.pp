class apache2::php5 {
  include apache2::fcgid

  package { php5-cgi: }

  apache2::confd_file { fcgid-php: 
    require => Package[libapache2-mod-fcgid]
  }

  file { "/etc/php5/cgi/conf.d/upload.ini":
    content => "upload_max_filesize = 5M\n",
    require => Package[php5-cgi]
  }
}

class apache2::php5::mysql {
  package { php5-mysql: }
}
