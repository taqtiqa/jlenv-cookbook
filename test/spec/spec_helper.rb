require 'chefspec'
require 'chefspec/policyfile' # TODO: Policyfiles

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
  end

  config.platform = 'ubuntu'
  config.version = '18.04'
end
