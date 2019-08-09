require_relative '../spec_helper'

describe 'test::user_install' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }
  let(:git) { chef_run.git('/home/vagrant/.jlenv') }

  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end
end
