class apache2::fcgid {
  package { libapache2-mod-fcgid: }
  apache2::confd_file { fcgid: 
    require => Package[libapache2-mod-fcgid]
  }
}
