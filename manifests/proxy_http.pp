class apache2::proxy_http {

  apache2::module { proxy: config => true }
  apache2::module { proxy_http: }

}
