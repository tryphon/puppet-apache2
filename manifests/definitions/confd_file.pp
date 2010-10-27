define apache2::confd_file($source = '') {
  $real_source = $source ? {
    '' => ["puppet:///files/apache2/conf.d/$name.$fqdn", "puppet:///files/apache2/conf.d/$name", "puppet:///apache2/conf.d/$name"],
    default => $source
  }
    
  file { "/etc/apache2/conf.d/$name":
    source => $real_source,
    notify => Service[apache2],
    require => Package[apache2]
  }
}
