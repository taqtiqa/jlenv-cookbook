# Install jlenv and makes it avilable to the selected user
version = '1.0.1'

# Make sure that Vagarant user is on the box for dokken
include_recipe 'test::dokken'

# Keeps the jlenv install upto date
jlenv_user_install 'vagrant'

jlenv_plugin 'julia-build' do
  git_url 'https://github.com/jlenv/julia-build.git'
  user 'vagrant'
end

jlenv_julia '1.0.4' do
  user 'vagrant'
end

jlenv_global version do
  user 'vagrant'
end
