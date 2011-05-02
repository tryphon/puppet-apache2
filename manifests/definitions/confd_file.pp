define apache2::confd_file($source = '', $content = false) {
  if $content {
    file { "/etc/apache2/conf.d/$name":
      content => $content,
      notify => Service[apache2],
      require => Package[apache2]
    }
  } else {
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
}
