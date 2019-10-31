# frozen_string_literal: true

system_version = '1.0.1'

# Ensure test setup
include_recipe 'shared::default'

# System Install
jlenv_system_install 'system'

# Install system wide Julia
jlenv_julia system_version

# Set System global version
jlenv_global system_version

# Uninstall Julia
jlenv_julia system_version do
  jlenv_action 'uninstall'
end
