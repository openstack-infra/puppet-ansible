require 'spec_helper_acceptance'

describe 'required python package' do
  describe package('ansible') do
    it { should be_installed.by('pip') }
  end
end
