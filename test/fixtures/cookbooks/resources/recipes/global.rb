# Spec resource usage with defaults.

# Ensure test setup
include_recipe 'shared::default'

global_version = 'v1.0.3'

# Install Jlenv Globally.
# TODO: Remove this step by installing the given version if not installed.
jlenv_system_install 'system'

jlenv_julia global_version do
  verbose true
end

# Set that Julia version as the global Julia
jlenv_global global_version
