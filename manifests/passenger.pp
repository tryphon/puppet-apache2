class apache2::passenger {
  include apache24
  include apt::backports
  include ruby::gems

  package { 'libapache2-mod-passenger':
    require => [Package[apache2], Apt::Sources_list["passenger"]]
  }

  include apache2::passenger::apt

  file { '/var/www/.passenger':
    ensure => directory,
    owner => www-data,
    require => Package['libapache2-mod-passenger']
  }

  file { '/var/log/apache2/passenger.log':
    ensure => present,
    owner => www-data,
    require => Package['libapache2-mod-passenger']
  }

  ruby::gem { fastthread: }

  apache2::module { passenger:
    config => true,
    require => Package[libapache2-mod-passenger]
  }

  apache2::confd_file { passenger: }

  include apache2::passenger::munin
}
