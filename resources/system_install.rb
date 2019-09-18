#
# Cookbook:: jlenv
# Resource:: system_install
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

# Install jlenv to a system wide location
provides :jlenv_system_install

property :git_url,       String, default: 'https://github.com/jlenv/jlenv.git'
property :git_ref,       String, default: 'master'
property :git_username,  String, default: 'root'
property :global_prefix, String, default: '/usr/local/jlenv'
property :update_jlenv, [true, false], default: true

action :install do
  node.run_state['root_path'] ||= {}
  node.run_state['root_path']['system'] = new_resource.global_prefix

  package package_prerequisites

  directory '/etc/profile.d' do
    owner 'root'
    mode '0755'
  end

  template '/etc/profile.d/jlenv.sh' do
    cookbook 'jlenv'
    source 'jlenv.sh.erb'
    owner 'root'
    mode '0755'
    variables(global_prefix: new_resource.global_prefix)
  end

  git new_resource.global_prefix do
    repository new_resource.git_url
    reference new_resource.git_ref
    action :checkout if new_resource.update_jlenv == false
    #notifies :run, 'bash[Initialize global git username]', :immediately
    notifies :run, 'ruby_block[Add jlenv to PATH]', :immediately
    notifies :run, 'bash[Initialize system jlenv]', :immediately
  end

  directory "#{new_resource.global_prefix}/plugins" do
    owner 'root'
    mode '0755'
  end

  # Initialize jlenv
  ruby_block 'Add jlenv to PATH' do
    block do
      ENV['PATH'] = "#{new_resource.global_prefix}/shims:#{new_resource.global_prefix}/bin:#{ENV['PATH']}"
    end
    action :nothing
  end

  # Git within dokken encounters the problem that /dev/tty is not available.
  # See also: https://stackoverflow.com/a/57458443/152860
  bash 'Initialize global git username' do
    code <<-EOH
      su -l #{node['current_user']} -c 'git config --global user.name #{new_resource.git_username||node['current_user']}'
    EOH
    flags "-x"
    action :nothing
  end

  bash 'Initialize system jlenv' do
    code %(PATH="#{new_resource.global_prefix}/bin:$PATH" jlenv init -)
    environment('JLENV_ROOT' => new_resource.global_prefix)
    action :nothing
  end
end

action_class do
  include Chef::Jlenv::Helpers
end
