# Install jlenv and makes it avilable to the selected user
version = '1.0.1'

# Ensure test setup
include_recipe 'shared::default'

group 'new-group' do
  members 'vagrant'
end

# Keeps the jlenv install upto date
jlenv_user_install 'vagrant' do
  user 'vagrant'
  group 'new-group'
end

# Install plugin to build Julia
jlenv_plugin 'julia-build' do
  git_url 'https://github.com/jlenv/julia-build.git'
  user 'vagrant'
end

jlenv_julia '1.0.1' do
  user 'vagrant'
end

jlenv_global version do
  user 'vagrant'
end
