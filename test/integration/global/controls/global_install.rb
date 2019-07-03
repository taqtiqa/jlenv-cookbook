# frozen_string_literal: true
global_julia = '2.4.1'

control 'Jlenv should be installed' do
  title 'Jlenv should be installed globally'

  desc "Can set global Ruby version to #{global_julia}"
  describe bash('source /etc/profile.d/jlenv.sh && jlenv versions --bare') do
    its('exit_status') { should eq 0 }
    its('stdout') { should include(global_julia) }
  end
end
