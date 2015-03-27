class sys11mcollective(
  $middleware = false,
  $securityprovider = 'psk',
) {

  if $middleware {
    class { 'sys11mcollective::middleware': }
  }

  case $securityprovider {
    # psk is default upstream, doing nothing
    'psk': { }
    'sshkey': { class { 'sys11mcollective::auth::sshkey': } }
    default: { fail('Unsupported security-provider in sys11mcollective') }
  }


  # When we use SSL for the broker mcollective wants all agents to authenticate themselves with certificates as well
  if hiera('mcollective::middleware_ssl', false) {

    class { '::mcollective':
      securityprovider   => $securityprovider,
      ssl_server_public  => "${::puppet_vardir}/ssl/certs/${::fqdn}.pem",
      ssl_server_private => "${::puppet_vardir}/ssl/private_keys/${::fqdn}.pem",
      ssl_ca_cert        => "${::puppet_vardir}/ssl/certs/ca.pem",
    }

  }
  else {
    class { '::mcollective':
      securityprovider  => $securityprovider,
    }
  }

  # When we use SSL for the broker mcollective wants all clients to authenticate themselves with certificates as well
  if hiera('mcollective::middleware_ssl', false) and hiera('mcollective::client', false) {
    mcollective::client::setting { 'plugin.rabbitmq.pool.1.ssl.cert':
      value => "${mcollective::confdir}/server_public.pem",
    }

    mcollective::client::setting { 'plugin.rabbitmq.pool.1.ssl.key':
      value => "${mcollective::confdir}/server_private.pem",
    }
  }

  class { 'sys11mcollective::plugins': }
}
