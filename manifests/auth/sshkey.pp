class sys11mcollective::auth::sshkey {

  package { 'mcollective-sshkey-security':
    ensure => installed,
  }

  # The sshkeyauth gem isn't packaged at the moment, use the puppet resource instead
  package { 'sshkeyauth':
    ensure   => installed,
    provider => gem,
    require  => Package['net-ssh'],
  }

  package { 'net-ssh':
    ensure   => '2.9.2',
    provider => gem,
  }

  # We use an exported resource that collects the SSH host keys from all nodes connected to the puppet master
  # These host keys then identify valid mcollective agent/servers in the mcollective cluster

  $known_hosts_file = '/etc/mcollective/ssh_known_hosts'

  mcollective::client::setting { 'plugin.sshkey.client.known_hosts':
    value => "$known_hosts_file",
  }

  @@sshkey { "${module_name}_${::hostname}":
    name   => $::hostname,
    type   => dsa,
    key    => $::sshdsakey,
    target => $known_hosts_file,
    tag    => $module_name,
  }

  Sshkey <<| tag == $module_name |>>
}
