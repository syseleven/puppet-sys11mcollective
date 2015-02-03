class sys11mcollective(
  $middleware = false,
  $securityprovider = 'psk',
) {

  if $middleware {
    class { 'sys11mcollective::middleware': }
  }

  case $securityprovider {
    # psk is default upstream, doing nothing
    # FIXME: empty placeholder?
    'psk': { $foo = 'bar' }
    'sshkey': { class { 'sys11mcollective::auth::sshkey': } }
    default: { fail('Unsupported security-provider in sys11mcollective') }
  }


  class { '::mcollective':
    securityprovider => $securityprovider,
  }

  class { 'sys11mcollective::plugins': }

}
