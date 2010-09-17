define apache2::proxy_site($target, $preserve_host = true, $content = '') {
  include apache2::proxy::http
  
  site { $name:
    content => template("apache2/reverse-proxy.conf")
  }
}
