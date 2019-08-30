require_relative '../resources_spec_helper'

describe 'resources::user_install' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end
end
