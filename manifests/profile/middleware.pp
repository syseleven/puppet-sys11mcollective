# This class prepares a RabbitMQ middleware service for use by MCollective.
# largely lifted from https://github.com/puppetlabs/puppetlabs-mcollective/blob/2.0.0/examples/mco_profile/manifests/middleware/rabbitmq.pp
class sys11mcollective::profile::middleware (
  $confdir                   = '/etc/rabbitmq',
  $vhost                     = '/mcollective',
  $delete_guest_user         = true,
  $middleware_port           = hiera('mcollective::middleware_port'),
  $middleware_user           = hiera('mcollective::middleware_user'),
  $middleware_password       = hiera('mcollective::middleware_password'),
  $middleware_admin_user     = hiera('mcollective::middleware_admin_user'),
  $middleware_admin_password = hiera('mcollective::middleware_admin_password'),
#  $ssl_ca_cert               = 
#  $ssl_server_cert           = 
#  $ssl_server_private        = 
#  $middleware_ssl_port       = 
) {

#  # Set up SSL files. Use copies of the PEM keys specified as parameters.
#  file { "${confdir}/ca.pem":
#    owner  => 'rabbitmq',
#    group  => 'rabbitmq',
#    mode   => '0444',
#    source => $ssl_ca_cert,
#    notify => Service['rabbitmq-server'],
#  }
#  file { "${confdir}/server_cert.pem":
#    owner  => 'rabbitmq',
#    group  => 'rabbitmq',
#    mode   => '0444',
#    source => $ssl_server_cert,
#    notify => Service['rabbitmq-server'],
#  }
#  file { "${confdir}/server_private.pem":
#    owner  => 'rabbitmq',
#    group  => 'rabbitmq',
#    mode   => '0400',
#    source => $ssl_server_private,
#    notify => Service['rabbitmq-server'],
#  }
#
  # Install the RabbitMQ service using the puppetlabs/rabbitmq module
  class { '::rabbitmq':
    config_stomp      => true,
    delete_guest_user => $delete_guest_user,
    ssl               => false,
    stomp_port        => $middleware_port,
#    ssl_stomp_port    => $middleware_ssl_port,
#    ssl_cacert        => "${confdir}/ca.pem",
#    ssl_cert          => "${confdir}/server_cert.pem",
#    ssl_key           => "${confdir}/server_private.pem",
  }
  contain rabbitmq

  # Configure the RabbitMQ service for use by MCollective
  rabbitmq_plugin { 'rabbitmq_stomp':
    ensure => present,
    notify => Service['rabbitmq-server'],
  }

  rabbitmq_vhost { $vhost:
    ensure => present,
    notify => Service['rabbitmq-server'],
  }

  rabbitmq_user { $middleware_user:
    ensure   => present,
    admin    => false,
    password => $middleware_password,
    notify   => Service['rabbitmq-server'],
  }
  rabbitmq_user { $middleware_admin_user:
    ensure   => present,
    admin    => true,
    password => $middleware_admin_password,
    notify   => Service['rabbitmq-server'],
  }

  rabbitmq_user_permissions { "${middleware_user}@${vhost}":
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
    notify               => Service['rabbitmq-server'],
  }
  rabbitmq_user_permissions { "${middleware_admin_user}@${vhost}":
    configure_permission => '.*',
    notify               => Service['rabbitmq-server'],
  }

  rabbitmq_exchange { "mcollective_broadcast@${vhost}":
    ensure   => present,
    type     => 'topic',
    user     => $middleware_admin_user,
    password => $middleware_admin_password,
  }
  rabbitmq_exchange { "mcollective_directed@${vhost}":
    ensure   => present,
    type     => 'direct',
    user     => $middleware_admin_user,
    password => $middleware_admin_password,
  }

}
