class apache2::deflate ($version = 22) {
  include apache2::headers
  apache2::module { deflate: }
  confd_file { deflate:
    require => [Apache2::Module[deflate], Apache2::Module[headers]],
    version => $version
  }
}
