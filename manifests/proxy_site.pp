define apache2::proxy_site($target, $preserve_host = true, $content = '', $ensure = 'present', $authentication = false, $ssl = false, $force_ssl = false, $aliases = [], $proxy_params = "") {
  include apache2::proxy_http

  site { $name:
    content => template("apache2/reverse-proxy-24.conf"),
    ensure  => $ensure,
  }

  if $authentication {
    File['/etc/apache2/htpasswd'] -> Site[$name]
  }
}
