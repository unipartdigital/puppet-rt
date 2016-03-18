require 'spec_helper'
describe 'rt' do

  context 'with defaults for all parameters' do
    it { should contain_class('rt') }
  end
end
