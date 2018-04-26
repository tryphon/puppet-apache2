class apache2::passenger::apt {
  include apt::https

  apt::sources_list { "passenger":
    content => "deb https://oss-binaries.phusionpassenger.com/apt/passenger ${debian::release} main",
    require => [Apt::Key["AC40B2F7"], Package[apt-transport-https]]
  }

  apt::key { "AC40B2F7":
    source => "puppet:///apache2/passenger/phusion.key"
  }
}
