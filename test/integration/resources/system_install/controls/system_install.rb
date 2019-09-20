# frozen_string_literal: true

title 'Jlenv System Install Resource'

control 'Jlenv system install' do
  title 'Jlenv should be installed system wide'

  desc 'Jlenv should be installed and run successfully'
  describe bash('source /etc/profile.d/jlenv.sh && jlenv versions --bare') do
    its('exit_status') { should eq 0 }
  end
end

control 'Jlenv system path' do
  title 'Jlenv should be installed in the system wide location'

  describe file('/usr/local/jlenv') do
    it { should exist }
    it { should be_directory }
  end

  # Issue: https://github.com/jlenv/jlenv-cookbook/issues/3
  # Issue: https://github.com/jlenv/jlenv-cookbook/issues/4
  # 
  describe file('/etc/profile.d/jlenv.sh') do
    its('type')  { should be_file }
    its('group') { should eq 'root' }
    its('owner') { should eq 'root' }
    its('mode')  { should cmp '0755' }
    it { should     be_executable.by('others') }
    it { should_not be_writable.by('others') }
  end

end
