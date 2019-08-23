# frozen_string_literal: true

#
# Cookbook:: jlenv
# Resource:: julia
#
# Author:: Fletcher Nichol <fnichol@nichol.ca>
# Author:: Dan Webb <dan.webb@damacus.io>
# Author:: Mark Van de Vyver <mark@taqtiqa.com>
#
# Copyright:: 2011-2018, Fletcher Nichol
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
provides :jlenv_julia

property :version,            String, name_property: true
property :version_file,       String
property :user,               String
property :environment,        Hash
property :jlenv_action,       String, default: 'install'
property :verbose,            [true, false], default: false
property :julia_build_git_url, String, default: 'https://github.com/jlenv/julia-build.git'

action :install do

  install_start = Time.now

  Chef::Log.info("Building Julia #{new_resource.version}, this could take a while...")

  jlenv_plugin 'julia-build' do
    git_url new_resource.julia_build_git_url
    user new_resource.user if new_resource.user
  end

  install_julia_dependencies

  # TODO: ?
  # patch_command = "--patch < <(curl -sSL #{new_resource.patch_url})" if new_resource.patch_url
  # patch_command = "--patch < #{new_resource.patch_file}" if new_resource.patch_file
  command = %(jlenv #{new_resource.jlenv_action})
  # From `jlenv help uninstall`:
  # -f  Attempt to remove the specified version without prompting
  #     for confirmation. If the version does not exist, do not
  #     display an error message.
  command << ' -f' if new_resource.jlenv_action == 'uninstall'
  command << " #{new_resource.version}"
  command << ' --verbose' if new_resource.verbose

  jlenv_script "#{command} #{which_jlenv}" do
    code command
    user new_resource.user if new_resource.user
    environment new_resource.environment if new_resource.environment
    action :run
    live_stream true if new_resource.verbose
    not_if { julia_installed? && new_resource.jlenv_action != 'uninstall' }
  end

  log_message = new_resource.to_s
  log_message << if new_resource.jlenv_action == 'uninstall'
                   ' uninstalled'
                 else
                   " build time was #{(Time.now - install_start) / 60.0} minutes"
                 end
  Chef::Log.info(log_message)

  # TODO: If there is no more Julia installed on the system, the `version` file
  # of jlenv still contains a version number which results in a warning. See
  # this issue and comment for more details:
  # https://github.com/rbenv/rbenv/pull/848#issuecomment-413857386
end

action_class do
  include Chef::Jlenv::Helpers
  include Chef::Jlenv::PackageDeps
end
