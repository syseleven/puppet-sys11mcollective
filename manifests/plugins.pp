class sys11mcollective::plugins {

  mcollective::plugin { 'puppet':
    package => true,
  }

  mcollective::plugin { 'shell':
    package => true,
  }

  mcollective::plugin { 'package':
    package => true,
  }

  mcollective::plugin { 'nettest':
    package => true,
  }

}
