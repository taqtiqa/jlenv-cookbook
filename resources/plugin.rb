#
# Cookbook:: jlenv
# Resource:: plugin
#
# Author:: Dan Webb <dan.webb@damacus.io>
# Author:: Mark Van de Vyver <mark@taqtiqa.com>
#
# Copyright:: 2017-2018, Dan Webb
# Copyright:: 2019, Mark Van de Vyver
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
provides :jlenv_plugin

property :git_url, String, default: 'https://github.com/jlenv/jlenv-build.git'
property :git_ref, String, default: 'master'
property :user,    String

# https://github.com/jlenv/jlenv/wiki/Plugins
action :install do
  # If we pass in a username, we then to a plugin install to the users home_dir
  # See chef_jlenv_script_helpers.rb for root_path
  git "Install #{new_resource.name} plugin" do
    destination ::File.join(root_path, 'plugins', new_resource.name)
    repository new_resource.git_url
    reference new_resource.git_ref
    user new_resource.user if new_resource.user
    action :checkout
  end
end

action_class do
  include Chef::Jlenv::Helpers
end
