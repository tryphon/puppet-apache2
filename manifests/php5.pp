class apache2::php5 {
  package { libapache2-mod-fcgid: }
  package { php5-cgi: }

  apache2::confd_file { fcgid-php: }

  file { "/etc/php5/cgi/conf.d/upload.ini":
    content => "upload_max_filesize = 5M\n",
    require => Package[php5-cgi]
  }
}
