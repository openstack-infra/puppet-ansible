require 'spec_helper_acceptance'

describe 'puppet-ansible module' do
  def pp_path
    base_path = File.dirname(__FILE__)
    File.join(base_path, 'fixtures')
  end

  def default_puppet_module
    module_path = File.join(pp_path, 'default.pp')
    File.read(module_path)
  end

  it 'should work with no errors' do
    apply_manifest(default_puppet_module, catch_failures: true)
  end

  it 'should be idempotent', :if => ['debian', 'ubuntu'].include?(os[:family]) do
    apply_manifest(default_puppet_module, catch_changes: true)
  end

  it 'should be idempotent', :if => ['fedora', 'redhat'].include?(os[:family]) do
    pending('this module is not idempotent on CentOS yet')
    apply_manifest(default_puppet_module, catch_changes: true)
  end

  describe 'required python package' do
    describe package('ansible') do
      it { should be_installed.by('pip') }
    end
  end

  describe 'required files' do
    describe file('/etc/ansible/ansible.cfg') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      its(:content) { should include 'library=/usr/share/ansible' }
    end

    describe file('/etc/logrotate.d/ansible') do
      its(:content) { should include '/var/log/ansible.log' }
    end
  end
end
