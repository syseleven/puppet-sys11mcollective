class sys11mcollective {

  include sys11mcollective::plugins

  if hiera('sys11mcollective::middleware', false)  {
    class { 'sys11mcollective::profile::middleware': }
  }

  class { '::mcollective': }

}
