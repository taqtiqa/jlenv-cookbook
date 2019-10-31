
# Ensure test setup
include_recipe 'shared::default'

# Julia build plugin should get installed to the user's jlenv.
jlenv_plugin 'julia-build' do
  user 'vagrant'
end

# Julia build plugin should get installed to the system_install.
jlenv_plugin 'julia-build' 
