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
end
