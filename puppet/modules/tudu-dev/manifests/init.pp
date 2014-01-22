class tudu-dev {
  class {'tudu-dev::ruby2': }

  package {'tmux': ensure=> 'installed'}
}
