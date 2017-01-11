# == Class: ansible
#
class ansible (
  $ansible_hostfile      = '/etc/ansible/hosts',
  $ansible_roles_path    = '/etc/ansible/roles',
  # Note this version is temporarily ignored while we install non
  # CVE 2016 9587 affected ansible via tarball because ansible doesn't
  # put their RCs on pypi.
  $ansible_version       = '2.0.2.0',
  $retry_files_enabled   = undef,
  $retry_files_save_path = undef,
) {

  include ::logrotate
  include ::pip

  exec { 'install-ansible-rc':
    command  => 'pip install https://releases.ansible.com/ansible/ansible-2.2.1.0-0.3.rc3.tar.gz',
    unless   => 'pip freeze | grep \'ansible==2.2.1.0\'',
    path     => '/usr/local/bin:/bin:/usr/bin',
    require  => Class['pip'],
  }

  if ! defined(File['/etc/ansible']) {
    file { '/etc/ansible':
      ensure  => directory,
    }
  }

  file { '/etc/ansible/ansible.cfg':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('ansible/ansible.cfg.erb'),
    require => File['/etc/ansible'],
  }

  ::logrotate::file { 'ansible':
    log     => '/var/log/ansible.log',
    options => [
      'compress',
      'copytruncate',
      'missingok',
      'rotate 7',
      'daily',
      'notifempty',
    ],
  }

}
