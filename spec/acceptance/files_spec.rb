require 'spec_helper_acceptance'

describe 'required files' do
  describe file('/etc/ansible/ansible.cfg') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its(:content) { should include 'library=/usr/share/ansible' }
  end

  describe file('/usr/local/bin/puppet-inventory') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its(:content) { should include "'_meta': {'hostvars': dict()}," }
  end

  describe file('/etc/logrotate.d/ansible') do
    its(:content) { should include '/var/log/ansible.log' }
  end
end
