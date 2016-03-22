import "classes/*.pp"
import "definitions/*.pp"

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
  confd_file { ["base","log","serverstatus","fqdn"]: }

  include apache2::common
}

class apache2::common ($version = 22) {

  $conf_dir = $version ? {
    22 => 'conf.d',
    24 => 'conf-available'
  }

  # Create useless other_vhosts_access.log
  file { "/etc/apache2/$conf_dir/other-vhosts-access-log":
    ensure => absent,
    notify => Service[apache2],
    require => Package[apache2]
  }

  # reduce apache2 log storage
  file { "/etc/logrotate.d/apache2":
    source => ["puppet:///files/apache2/apache2.logrotate.${fqdn}", "puppet:///apache2/apache2.logrotate"],
    require => Package[apache2],
    mode => 644
  }

  $apache2_conf = $version ? {
    22 => 'apache2.conf',
    24 => 'apache24.conf',
  }
  file { "/etc/apache2/apache2.conf":
    source => "puppet:///apache2/$apache2_conf",
    require => [Package[apache2], File["/etc/apache2/httpd.conf"]],
    notify => Service[apache2]
  }

  file { "/etc/apache2/httpd.conf":
    ensure => present,
    require => Package[apache2]
  }

  file { "/etc/apache2/ports.conf":
    source => ["puppet:///files/apache2/ports.conf.${fqdn}", "puppet:///apache2/ports.conf"],
    require => Package[apache2],
    notify => Service[apache2]
  }

  $mime_types_name = $version ? {
    22 => 'mime_type',
    24 => 'mime_type.conf'
  }
  # Additional MIME types to default list
  file { "/etc/apache2/$conf_dir/$mime_types_name":
    source => 'puppet:///apache2/mime_types.conf',
    require => Package['apache2']
  }

  # histoire de reloader apache2 quand la conf change
  # fonctionne partiellement
  file { "/etc/apache2":
    ensure => directory,
    recurse => true
  }

  file { "/etc/apache2/users":
    mode => 640,
    owner => www-data,
    group => adm,
    ensure => present
  }

  # ensure => directory removes symlinks ...
  exec { "create-var-www-if-needed":
    command => "mkdir /var/www",
    creates => "/var/www"
  }
  file { "/var/www":
    require => Exec["create-var-www-if-needed"]
  }

  file { "/var/www/default":
    ensure => directory
  }
  file { "/var/www/default/index.html":
    ensure => present
  }

  site { "default":
    link => "000-default",
    require => File["/var/www/default"],
    source => ["puppet:///files/apache2/sites-available/default.${fqdn}", "puppet:///files/apache2/sites-available/default", "puppet:///apache2/default.conf"]
  }

  if $apache_server_admin {
    $real_name = $version ? {
      22 => 'server_admin',
      24 => 'server_admin.conf'
    }
    file { "/etc/apache2/$conf_dir/$real_name":
      content => "ServerAdmin $apache_server_admin\n",
      notify => Service[apache2],
      require => Package[apache2]
    }
  }

  include apache2::munin
}

class apache2::munin {

  munin::plugin {
    [apache_accesses, apache_processes, apache_volume]:
    require => Package[libwww-perl]
  }

  include perl::lib::www
}
