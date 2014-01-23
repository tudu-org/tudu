class tudu-dev {
  exec {'apt-update':
    command => '/usr/bin/apt-get update',
  }

  package {'tmux':
    ensure => 'installed',
    require => Exec['apt-update'],
  }
  package {'ruby-dev':
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
