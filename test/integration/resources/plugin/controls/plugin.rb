# frozen_string_literal: true

title 'Jlenv Plugin Resource Defaults'

control 'julia-build plugin should be installed' do
  title 'julia-build should be installed to the users home directory'
  
  desc 'Jlenv should be installed and run successfully'
  describe bash('source /etc/profile.d/jlenv.sh && jlenv versions --bare') do
    its('exit_status') { should eq 0 }
  end

  desc 'Julia build versions available can now be listed.'
  describe bash("sudo -H -u #{julia_user} bash -c 'source /etc/profile.d/jlenv.sh && jlenv install -l'") do
    its('exit_status') { should eq 0 }
    its('stdout') { should include(user_julia_version) }
    its('stderr') { should eq '' }
  end
end
