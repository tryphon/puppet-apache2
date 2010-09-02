class apache2::proxy::http {

  apache2::module { proxy: config => true }
  apache2::module { proxy_http: }

}
