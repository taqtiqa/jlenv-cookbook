# Install Jlenv to the system path e.g. /usr/local/jlenv

# Ensure Vagrant user exists on test environment
include_recipe 'test::default'

jlenv_system_install 'system' do
  update_jlenv false
end
