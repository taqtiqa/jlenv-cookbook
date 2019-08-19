# Make sure that Vagarant user is on the box for dokken
include_recipe 'test::dokken'

# System Install
jlenv_system_install 'system'
# Install several Julias to a system wide location
jlenv_julia '1.0.4' do
  verbose true
end

jlenv_julia '1.1.0' do
  verbose true
end

# Set System global version
jlenv_global '1.0.4'

#####################################################################
#
# JuliaRegistries/General Hosted Repository
#
#####################################################################

# Default is latest from default registry to global Julia
jlenv_pkg 'DataFrames'

jlenv_pkg 'DataFrames' do
  action :remove
end

# Registry add by version numbers
jlenv_pkg 'DataFrames' do
  version '0.15.2'
  jlenv_version '1.1.0'
  action :add
end

# Registry remove action
jlenv_pkg 'DataFrames' do
  version '0.15.2'
  jlenv_version '1.0.4'
  action :remove
end

# Registry by UUID numbers
jlenv_pkg 'DataFrames' do
  uuid 'a93c6f00-e57d-5684-b7b6-d8193f3e46c0'
  jlenv_version '1.0.4'
end

# Registry by branch name
jlenv_pkg 'DataFrames' do
  branch 'master'
  jlenv_version '1.1.0'
end

# Registry hash
jlenv_pkg 'DataFrames' do
  hash '279baa63'
  jlenv_version '1.1.0'
end

# Registry version
jlenv_pkg 'General Registry Data Frames' do
  name 'DataFrames'
  version '0.15.1'
  jlenv_version '1.1.0'
end

# Registry nomination
jlenv_pkg 'DataFrames' do
  registry 'https://github.com/JuliaRegistries/General'
  version '0.15.2'
  jlenv_version '1.1.0'
end

#####################################################################
#
# Git Hosted Repository
#
#####################################################################

# Remote git branch.
jlenv_pkg 'Free Text' do
  repo 'https://github.com/JuliaData/DataFrames.jl'
  branch 'master'
  jlenv_version '1.1.0'
end

# Remote git version.
jlenv_pkg 'Free Text' do
  url 'https://github.com/JuliaData/DataFrames.jl'
  version '0.18.2'
  jlenv_version '1.1.0'
end

# Remote git version.
jlenv_pkg 'Free Text' do
  url 'https://github.com/JuliaData/DataFrames.jl'
  hash '279baa6358fd5e944deccab88434f69c74cfc722'
  jlenv_version '1.1.0'
end

# Local (bare) git branch
jlenv_pkg 'Free Text' do
  repo 'file:///src/DataFrames.jl.git'
  branch 'master'
  jlenv_version '1.1.0'
end

# Local (bare) git hash
jlenv_pkg 'Bare repository' do
  repo 'file:///src/DataFrames.jl.git'
  hash '3891a62fd843662af9f78f25bdd415530b9b9c1e'
  jlenv_version '1.1.0'
end

# Install latest for specific user
jlenv_user_install 'vagrant'

# Install a Julia to a user directory
jlenv_julia '1.1.0' do
  user 'vagrant'
end

# Set the vagrant global version
jlenv_global '1.1.0' do
  user 'vagrant'
end
