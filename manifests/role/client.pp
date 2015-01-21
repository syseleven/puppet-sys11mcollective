class sys11mcollective::role::client() {
  anchor { 'sys11mcollective::begin': }
  class {'sys11mcollective::profile::client': }
  anchor { 'sys11mcollective::end': }
}
