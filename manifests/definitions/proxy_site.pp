define apache2::proxy_site($target, $preserve_host = true, $content = '', $ensure = 'present', $authentication = false) {
  include apache2::proxy::http

  site { $name:
    content => template("apache2/reverse-proxy.conf"),
    ensure => $ensure,
  }

  if $authentication {
    File['/etc/apache2/htpasswd'] -> Site[$name]
  }
}
