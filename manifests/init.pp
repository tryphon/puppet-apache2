class apache2 {

  package { apache2-mpm-worker:
    alias => apache2,
    ensure => installed
  }

  service { apache2:
    ensure    => running,
    subscribe => File["/etc/apache2"],
    require => Package[apache2],
    hasrestart => true
  }

  # configuration de base (log, ...)
  apache2::confd_file { ["base","log","serverstatus","fqdn"]: }

  include apache2::common
}


