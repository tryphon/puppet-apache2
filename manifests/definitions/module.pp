define apache2::module($config = false) {
  file { "/etc/apache2/mods-enabled/$name.load":
    ensure => "/etc/apache2/mods-available/$name.load",
    notify => Service[apache2],
    require => Package[apache2]
  }

  if $config {
    file { "/etc/apache2/mods-enabled/$name.conf":
      ensure => "/etc/apache2/mods-available/$name.conf",
      notify => Service[apache2],
      require => Package[apache2]
    }
  }
}
