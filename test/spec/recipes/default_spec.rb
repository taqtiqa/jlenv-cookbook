require_relative '../spec_helper'

describe 'jlenv::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new.converge(described_recipe)
  end

  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end

  # it 'installs a file' do
  #   expect(chef_run).to create_file('/tmp/foobar')
  # end
end
