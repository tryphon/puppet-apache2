class apache2::munin {

  munin::plugin {
    [apache_accesses, apache_processes, apache_volume]:
    require => Package[libwww-perl]
  }

  include perl::lib::www
}
