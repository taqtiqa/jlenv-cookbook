
# Use case

# Ensure Vagrant user exists on test environment
include_recipe 'test::default'

global_version = '1.0.3'

# Install Jlenv Globally
jlenv_system_install 'system'

# jlenv_julia global_version do
#   verbose true
# end

# Set that Julia version as the global Julia
jlenv_global global_version
