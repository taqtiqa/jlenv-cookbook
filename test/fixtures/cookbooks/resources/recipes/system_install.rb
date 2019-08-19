# Install Jlenv to the system path e.g. /usr/local/jlenv

# Ensure test setup
include_recipe 'shared::default'

jlenv_system_install 'system' do
  update_jlenv false
end
