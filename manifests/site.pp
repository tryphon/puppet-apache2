define apache2::site($link = '', $source = '', $content = false, $ensure = 'present') {
  if $ensure == 'present' {
    $real_source = $source ? {
      '' => "puppet:///files/apache2/sites-available/$name",
      default => $source
    }

    # install and enable a given site configuration
    if $content {
      file { "/etc/apache2/sites-available/$name.conf":
        content => $content,
        notify  => Service[apache2],
        require => Package[apache2]
      }
    } else {
      file { "/etc/apache2/sites-available/$name.conf":
        source  => $real_source,
        notify  => Service[apache2],
        require => Package[apache2],
        links   => follow
      }
    }

    file {
      $link ? {
        ''      => "/etc/apache2/sites-enabled/$name.conf",
        default => "/etc/apache2/sites-enabled/$link"
      } :
      ensure  => "/etc/apache2/sites-available/$name.conf",
      require => File["/etc/apache2/sites-available/$name.conf"],
      notify  => Service[apache2]
    }
  } else {
    file { "/etc/apache2/sites-available/$name.conf":
      ensure  => $ensure,
      notify  => Service[apache2],
      require => Package[apache2]
    }
    file {
      $link ? {
        ''      => "/etc/apache2/sites-enabled/$name.conf",
        default => "/etc/apache2/sites-enabled/$link"
      } :
      ensure  => $ensure,
      notify  => Service[apache2],
      require => Package[apache2]
    }
  }
}
