define apache2::proxy_site($target, $preserve_host = true, $content = '', $ensure = 'present', $authentication = false, $ssl = false, $aliases = []) {
  include apache2::proxy::http

  site { $name:
    content => template("apache2/reverse-proxy.conf"),
    ensure => $ensure,
  }

  if $authentication {
    File['/etc/apache2/htpasswd'] -> Site[$name]
  }
}
define apache24::proxy_site($target, $preserve_host = true, $content = '', $ensure = 'present', $authentication = false, $ssl = false, $aliases = []) {
  include apache2::proxy::http

  apache24::site { $name:
    content => template("apache2/reverse-proxy-24.conf"),
    ensure => $ensure,
  }

  if $authentication {
    File['/etc/apache2/htpasswd'] -> Apache24::Site[$name]
  }
}
