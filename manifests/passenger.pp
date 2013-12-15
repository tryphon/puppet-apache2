class apache2::passenger {
  include apache2
  include apt::backports
  include ruby::gems

  package { libapache2-mod-passenger:
    require => Package[apache2]
  }

  if $debian::lenny {
    apt::preferences { libapache2-mod-passenger:
      package => libapache2-mod-passenger,
      pin => "release a=lenny-backports",
      priority => 999,
      require => Apt::Sources_list[lenny-backports],
      before => Package[libapache2-mod-passenger]
    }
  } else {
    include apt::https

    apt::sources_list { "passenger":
      content => "deb https://oss-binaries.phusionpassenger.com/apt/passenger ${debian::release} main",
      require => Apt::Key["AC40B2F7"],
      before => Package[libapache2-mod-passenger],
      require => Package[apt-transport-https]
    }

    apt::key { "AC40B2F7":
      source => "puppet:///apache2/passenger/phusion.key"
    }
  }

  ruby::gem { fastthread: }

  apache2::module { passenger:
    config => true,
    require => Package[libapache2-mod-passenger]
  }

  apache2::confd_file { passenger: }

  include apache2::passenger::munin
}

class apache2::passenger::munin {
  munin::plugin { passenger_memory:
    source => "puppet:///apache2/munin/passenger_memory",
    config => "user root"
  }
  munin::plugin { passenger_status:
    source => "puppet:///apache2/munin/passenger_status",
    config => "user root"
  }
}
