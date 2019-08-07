require_relative '../spec_helper'

describe 'test::user_install' do
  let(:chef_run) do
    #ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe)
    # USe platform and version set in spec_helper.rb
    ChefSpec::SoloRunner.new.converge(described_recipe)
  end

  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end
end
