# frozen_string_literal: true

title 'Jlenv User Install Resource'

# Default user in resources is jovyan i.e. Jupyter assumption
julia_users        ||= yaml(content: inspec.profile.file('users.yml'))['users']
julia_user         ||= 'vagrant' 
user_julia_version ||= julia_users[julia_user]['version']

control 'Jlenv should be installed' do
  impact 0.6
  title 'Jlenv should be installed under the users home directory.'
  desc  'Always specify environment variables, folders and permissions.'
  desc  'Rationale:', 'This ensures that there are no unexpected scripts run.' # Requires InSpec >=2.3.4
  tag   'julia', 'jlenv'
  #ref   'NSA-RH6-STIG - Section 3.5.2.1', url: 'https://www.nsa.gov/ia/_files/os/redhat/rhel5-guide-i731.pdf'

  describe bash("sudo -H -u #{julia_user} bash -c 'source /etc/profile.d/jlenv.sh && jlenv global'") do
    its('exit_status') { should eq 0 }
    its('stdout') { should include('system') }
    its('stdout') { should not_include(user_julia_version) }
    its('stderr') { should eq '' }
  end

  %w(plugins shims versions).each do |d|
    describe directory("/home/#{julia_user}/.jlenv/#{d}") do
      its('type') { should be_file }
      its('mode') { should cmp '0755' }
      it { should exist }
      it { should be_writable.by_user(julia_user) }
    end
  end

  # Issue: https://github.com/jlenv/jlenv-cookbook/issues/3
  # Refactor this control to verify the user install script has had no
  # (unintended/specified) side effect on the system install (and vice versa).
  describe file('/etc/profile.d/jlenv.sh') do
    it { should_not be_writable.by_user(julia_user) }
    it { should be_executable.by('others') }
    it { should be_executable.by_user(julia_user) }
  end

  it 'checkouts from git with attributes' do
    is_expected.to checkout_git("/home/#{julia_user}/.jlenv").with(
      repository: 'https://github.com/jlenv/jlenv.git',
      reference: 'master'
      )
  end

  describe os_env('PATH', 'target') do
    its('split') { should_not include('') }
    its('split') { should_not include('.') }
    its('split') { should include("/home/#{julia_user}/.jlenv/shims") }
  end
end

control 'Global Jlenv' do
  title 'Jlenv should be installed globally'

  desc "Can set global Julia version to #{user_julia_version}"
  describe bash("sudo -H -u #{julia_user} bash -c 'source /etc/profile.d/jlenv.sh && jlenv versions --bare'") do
    its('exit_status') { should eq 0 }
    its('stdout') { should include(user_julia_version) }
    its('stderr') { should eq '' }
  end
end

jlenv_env_vars = %w(
  HOME
  JLENV_ROOT
  PATH
)

jlenv_env_vars.each do |e|
  describe os_env(e) do
    its('content') { should_not eq nil }
    its('content') { should_not eq '' }
  end
end
