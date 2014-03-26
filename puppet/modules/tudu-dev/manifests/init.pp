class tudu-dev {
  file {'/etc/apt/sources.list':
    ensure => 'file',
    source => 'puppet:///modules/tudu-dev/sources.list',
  }

  exec {'apt-update':
    command => '/usr/bin/apt-get update || true',
    require => File['/etc/apt/sources.list'],
  }

  package {'tmux':
    ensure => 'installed',
    require => Exec['apt-update'],
  }

  package {'ruby-dev':
    ensure => 'installed',
    require => Exec['apt-update'],
  }

  package {'libsqlite3-dev':
    ensure => 'installed',
    require => Exec['apt-update'],
  }

  package {'nodejs':
    ensure => 'installed',
    require => Exec['apt-update'],
  }

  package {'vim':
    ensure => 'installed',
    require => Exec['apt-update'],
  }

  package {'postgresql':
    ensure => 'installed',
    require => Exec['apt-update'],
  }

  package {'postgresql-client':
    ensure => 'installed',
    require => Exec['apt-update'],
  }

  package {'bundler':
    ensure => 'installed',
    provider => 'gem',
  }

  package {'rails':
    ensure => 'installed',
    provider => 'gem',
    require => Package['ruby-dev'],
  }
}
