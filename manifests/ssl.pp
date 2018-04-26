class apache2::ssl {
  apache2::module { ssl: }

  file { "/etc/apache2/ssl_params.conf":
    source => "puppet:///modules/apache2/ssl_params.conf"
  }
}
