# frozen_string_literal: true

global_system_julia = '2.5.1'

control 'Ruby uninstall' do
  title 'Ruby should be uninstalled'

  desc "#{global_system_julia} should be uninstalled"
  describe bash('source /etc/profile.d/jlenv.sh && jlenv versions --bare') do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not match(/#{Regexp.quote(global_system_julia)}/) }
  end
end
