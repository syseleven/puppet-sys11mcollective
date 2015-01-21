class sys11mcollective::role::middleware() {
  anchor { 'sys11mcollective::begin': }
  class {'sys11mcollective::profile::middleware': }
  anchor { 'sys11mcollective::end': }
}
