# frozen_string_literal: true

title 'Jlenv User Install Example Recipe'

control 'Jlenv should be installed' do
  impact 0.6
  title 'Jlenv should be installed uner the users home directory.'
  desc  'Always specify environment variables, folders and permissions.'
  desc  'rationale', 'This ensures that there are no unexpected scripts run.' # Requires InSpec >=2.3.4
  tag   'julia','jlenv'
  #ref   'NSA-RH6-STIG - Section 3.5.2.1', url: 'https://www.nsa.gov/ia/_files/os/redhat/rhel5-guide-i731.pdf'

  global_julia = '1.0.1'

  describe bash('sudo -H -u vagrant bash -c "source /etc/profile.d/jlenv.sh && jlenv global"') do
    its('exit_status') { should eq 0 }
    its('stdout') { should include(global_julia) }
  end

  %w(plugins shims versions).each do |d|
    describe directory("/home/vagrant/.jlenv/#{d}") do
      it { should exist }
      it { should be_writable.by_user('vagrant') }
      its('mode') { should cmp '0755' }
    end
  end

  describe file('/etc/profile.d/jlenv.sh') do
    its('group') { should eq 'admins' }
    its('user') { should eq 'root' }
    its('mode') { should cmp '0755' }
    it { should_not be_writable.by_user('vagrant') }
    it { should be_executable.by('others') }
    it { should be_executable.by_user('vagrant') }
  end

  it 'checkouts from git with attributes' do
    is_expected.to checkout_git('/home/vagrant/.jlenv').with(
      repository: 'https://github.com/jlenv/jlenv.git',
      reference: 'master'
      )
  end

  describe os_env('PATH', 'target') do
    its('split') { should_not include('') }
    its('split') { should_not include('.') }
    its('split') { should include ('/home/vagrant/.jlenv/shims') }
  end
end

control 'julia-build plugin should be installed' do
  title 'julia-build should be installed to the users home directory'
  describe bash('sudo -H -u vagrant bash -c "source /etc/profile.d/jlenv.sh && jlenv install -l"') do
    its('exit_status') { should eq 0 }
    its('stdout') { should include('2.3.4') }
    its('stdout') { should include(global_julia) }
  end
end

control 'Global Julia' do
  title 'Jlenv should be installed globally'

  desc "Can set global Julia version to #{global_julia}"
  describe bash('sudo -H -u vagrant bash -c "source /etc/profile.d/jlenv.sh && jlenv versions --bare"') do
    its('exit_status') { should eq 0 }
    its('stdout') { should include(global_julia) }
  end
end
