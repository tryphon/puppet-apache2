define apache2::site($link = '', $source = '', $content = false) {
  $real_source = $source ? {
    '' => "puppet:///files/apache2/sites-available/$name",
    default => $source
  }

  # install and enable a given site configuration
  if $content {
    file { "/etc/apache2/sites-available/$name":
      content => $content,
      notify => Service[apache2],
      require => Package[apache2]
    }
  } else {
    file { "/etc/apache2/sites-available/$name":
      source => $real_source,
      notify => Service[apache2],
      require => Package[apache2]
    }
  }

  file {
    $link ? {
      '' => "/etc/apache2/sites-enabled/$name",
      default => "/etc/apache2/sites-enabled/$link"
    } :
    ensure => "/etc/apache2/sites-available/$name",
    require => File["/etc/apache2/sites-available/$name"],
    notify => Service[apache2]
  }
}
