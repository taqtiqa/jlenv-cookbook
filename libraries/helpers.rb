#
# Cookbook:: jlenv
# Library:: Chef::Jlenv::ShellHelpers
#
# Author:: Fletcher Nichol <fnichol@nichol.ca>
# Author:: Mark Van de Vyver <mark@taqtiqa.com>
#
# Copyright:: 2011-2017, Fletcher Nichol
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
require_relative 'lib/chef/provider/git_ext'

class Chef
  module Jlenv
    module Helpers
      def wrap_shim_cmd(cmd)
        [%(export JLENV_ROOT="#{jlenv_root}"),
         %(export PATH="$JLENV_ROOT/bin:$JLENV_ROOT/shims:$PATH"),
         %(export JLENV_VERSION="#{new_resource.jlenv_version}"),
         %($JLENV_ROOT/shims/#{cmd}),
        ].join(' && ')
      end

      def root_path
        node.run_state['root_path'] ||= {}

        if new_resource.user
          node.run_state['root_path'][new_resource.user]
        else
          node.run_state['root_path']['system']
        end
      end

      def which_jlenv
        "(#{new_resource.user || 'system'})"
      end

      def binary
        prefix = new_resource.user ? "sudo -u #{new_resource.user} " : ''
        "#{prefix}#{root_path}/versions/#{new_resource.jlenv_version}/bin/gem"
      end

      def script_code
        script = []
        script << %(export JLENV_ROOT="#{root_path}")
        script << %(export PATH="${JLENV_ROOT}/bin:$PATH")
        script << %{eval "$(jlenv init -)"}
        if new_resource.jlenv_version
          script << %(export JLENV_VERSION="#{new_resource.jlenv_version}")
        end
        script << new_resource.code
        script.join("\n").concat("\n")
      end

      def script_environment
        script_env = { 'JLENV_ROOT' => root_path }

        script_env.merge!(new_resource.environment) if new_resource.environment

        if new_resource.path
          script_env['PATH'] = "#{new_resource.path.join(':')}:#{ENV['PATH']}"
        end

        if new_resource.user
          script_env['USER'] = new_resource.user
          script_env['HOME'] = ::File.expand_path("~#{new_resource.user}")
        end

        script_env
      end

      def package_prerequisites
        case node['platform_family']
        when 'rhel', 'fedora', 'amazon'
          %w(git grep tar)
        when 'debian', 'suse'
          case node['platform']
          when 'ubuntu'
            case node['platform_version']
            when '18.04'
              %w(git grep)
            else
              %w(git grep) 
            end
          else
            %w(git grep)
          end
        when 'mac_os_x', 'gentoo'
          %w(git)
        when 'freebsd'
          %w(git bash)
        when 'arch'
          %w(git grep)
        end
      end

      def julia_installed?
        if Array(new_resource.action).include?(:reinstall)
          return false
        elsif ::File.directory?(::File.join(root_path, 'versions', new_resource.version))
          return true
        end

        false
      end

      def verbose
        return '-v' if new_resource.verbose
      end
    end
  end
end
