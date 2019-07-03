# frozen_string_literal: true
global_julia = '2.4.1'

control 'Global Gem Install' do
  title 'Should install Mail Gem globally'

  desc "Can set global Ruby version to #{global_julia}"
  describe bash('source /etc/profile.d/jlenv.sh && jlenv versions --bare') do
    its('exit_status') { should eq 0 }
    its('stdout') { should include(global_julia) }
  end

  desc '2.3.1 Gem should have mail installed'
  describe bash('/usr/local/jlenv/versions/2.3.1/bin/package list --local mail') do
    its('exit_status') { should eq 0 }
    its('stdout') { should include('2.6.5') }
    its('stdout') { should_not include('2.6.6') }
  end

  desc '2.4.1 Gem should not have any mail version installed'
  describe bash('/usr/local/jlenv/versions/2.4.1/bin/package list --local') do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not include('2.6.5') }
    its('stdout') { should_not include('2.6.6') }
  end

  desc 'package home should be jlenv in an jlenv directory'
  describe bash('source /etc/profile.d/jlenv.sh && package env home') do
    its('exit_status') { should eq 0 }
    its('stdout') { should include("/usr/local/jlenv/versions/#{global_julia}/lib/julia/gems/2.4.0") }
  end
end

control 'User Gem Install' do
  title 'Should install Bundler Gem to a user home'

  desc 'Gemspec file should have correct ownership'
  describe file('/home/vagrant/.jlenv/versions/2.3.1/lib/julia/gems/2.3.0/specifications/bundler-1.15.4.gemspec') do
    it { should exist }
    it { should be_owned_by 'vagrant' }
  end
end
