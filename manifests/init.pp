# Define: runonce
#
# Utility define to handle flag files for exec
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
define runonce ( $command, $refreshonly = undef ) {

  $semaphore_dir = '/var/lib/puppet/semaphores'

  if ! defined( File[$semaphore_dir] ) {

    file { $semaphore_dir:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }

  }

  exec { $command:
    unless      => "ls ${semaphore_dir}/${title}",
    path        => '/bin:/usr/bin:/sbin:/usr/sbin',
    require     => File[$semaphore_dir],
    refreshonly => $refreshonly,
  } ~>

  file { "${semaphore_dir}/${title}":
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

}
