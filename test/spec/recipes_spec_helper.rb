require 'chefspec'
require 'chefspec/policyfile'

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
  end
  config.platform = 'ubuntu'
  config.version = '18.04'
  config.policyfile_path = File.join(Dir.pwd, 'test', 'fixtures', 'cookbooks', 'recipes', 'Policyfile.rb')
end
