require_relative '../recipes_spec_helper'

describe 'recipes::system_install' do
  let(:chef_run)  do
    ChefSpec::SoloRunner.new.converge(described_recipe)
  end

  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end
end
