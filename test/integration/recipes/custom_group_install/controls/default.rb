# frozen_string_literal: true

global_julia = '1.0.1'

control 'Jlenv should be installed' do
  title 'Jlenv should be installed to the users home directory'

  desc 'Jlenv should be installed'
  describe bash('sudo -H -u vagrant bash -c "source /etc/profile.d/jlenv.sh && jlenv global"') do
    its('exit_status') { should eq 0 }
    its('stdout') { should include(global_julia) }
  end

  describe file('/home/vagrant/.jlenv/versions') do
    it { should exist }
    it { should be_writable.by_user('vagrant') }
    its('group') { should eq 'new-group' }
  end

  describe file('/home/vagrant/.jlenv') do
    it { should exist }
    it { should be_writable.by_user('vagrant') }
    its('group') { should eq 'new-group' }
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
