#
# Cookbook:: jlenv
# Resource:: rehash
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
provides :jlenv_rehash

property :user, String

action :run do
  jlenv_script "jlenv rehash #{which_jlenv}" do
    code %(jlenv rehash)
    user new_resource.user if new_resource.user
    action :run
  end
end

action_class do
  include Chef::Jlenv::Helpers
end
