global_version = '1.0.3'

# Install Jlenv Globally
jlenv_system_install 'system'

jlenv_julia global_version do
  verbose true
end

# Make sure that Vagarant user is on the box for dokken
include_recipe 'test::dokken'

# Set that Julia as the global Julia
jlenv_global global_version
