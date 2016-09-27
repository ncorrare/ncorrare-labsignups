require 'spec_helper'
describe 'labsignups' do

  context 'with default values for all parameters' do
    it { should contain_class('labsignups') }
  end
end
