class sys11mcollective::plugins(
  $plugins = []
) {

  # mcollective::plugin will install -agent and -client package variants as needed

  ::mcollective::plugin { $plugins:
    package => true,
  }
}
