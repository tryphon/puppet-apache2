class apache2::passenger::munin {
  munin::plugin { passenger_memory:
    source => "puppet:///modules/apache2/munin/passenger_memory",
    config => "user root"
  }
  munin::plugin { passenger_status:
    source => "puppet:///modules/apache2/munin/passenger_status",
    config => "user root"
  }
}
