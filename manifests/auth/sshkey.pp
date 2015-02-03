class sys11mcollective::auth::sshkey {

  package { 'mcollective-sshkey-security':
    ensure => installed,
  }

  # YOLO
  package { 'sshkeyauth':
    ensure   => installed,
    provider => gem,
  }

  $known_hosts_file = '/etc/mcollective/ssh_known_hosts'

  @@sshkey { $::hostname:
    type => dsa,
    key => $::sshdsakey,
    target => $known_hosts_file,
  }

  Sshkey <<| |>>

  mcollective::client::setting { 'plugin.sshkey.client.known_hosts':
    value => "$known_hosts_file",
  }

}
