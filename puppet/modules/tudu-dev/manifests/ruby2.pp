class tudu-dev::ruby2 {
  exec {'add-apt-repository':
    command => '/usr/bin/add-apt-repository -y ppa:brightbox/ruby-ng-experimental'
  }

  package {'ruby2.0':
    ensure => 'installed',
    require => Exec['add-apt-repository'],
  }

  package {'ruby2.0-dev':
    ensure => 'installed',
    require => Exec['add-apt-repository'],
  }

  package {'ruby2.0-doc':
    ensure => 'installed',
    require => Exec['add-apt-repository'],
  }
}
