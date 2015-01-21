class sys11mcollective(
  $middleware = false,
) {

  if $middleware {
    class { 'sys11mcollective::profile::middleware': }
  }

  class { '::mcollective': }
  class { 'sys11mcollective::plugins': }

}
