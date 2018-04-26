class apache2::xsendfile {
  package { libapache2-mod-xsendfile:
    require => Package[apache2]
  }

  if $debian::lenny {
    apt::preferences { libapache2-mod-xsendfile:
      package => libapache2-mod-xsendfile,
      pin => "release a=lenny-backports",
      priority => 999,
      before => Package[libapache2-mod-xsendfile]
    }
  }

  apache2::module { xsendfile: }
}
