version = '1.0.1'

# Make sure that Vagarant user is on the box for dokken
include_recipe 'test::dokken'

jlenv_user_install 'vagrant'

jlenv_system_install 'system'

jlenv_julia version do
  install_julia_build false
  user 'vagrant'
end

jlenv_global version do
  user 'vagrant'
end

jlenv_plugin 'julia-build' do
  git_url 'https://github.com/jlenv/julia-build.git'
  user 'vagrant'
end

# This should get installed to the system_install
jlenv_plugin 'julia-build' do
  git_url 'git@github.com:jlenv/julia-build.git'
  git_ref 'bb86c68'
end
