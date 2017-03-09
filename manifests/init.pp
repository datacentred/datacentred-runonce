# === Define: runonce
#
# Utility define to handle flag files for exec
#
# === Parameters
#
# [*command*]
#   The command to execute
#
# [*persistent*]
#   Will the run once semantic persist across reboots
#
# [*persistent_dir*]
#   Directory containing perisistent semaphores
#
# === Examples
#
# runonce { 'hello-world':
#   command => 'echo hello world!',
# }
#
# runonce { 'init-modules':
#   command    => 'service kmod start',
#   persistent => false,
# }
#
define runonce (
  $command,
  $user = undef,
  $cwd = undef,
  $timeout = 200,
  $persistent     = true,
  $persistent_dir = '/etc/puppetlabs/puppet/semaphores'
) {

  # Ensure this particular persistent semaphore
  # directory is only defined once
  if ! defined( File[$persistent_dir] ) {

    # TODO: parent directory creation is not supported
    file { $persistent_dir:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }

  }

  # Select which directory to place the semaphore
  # in to.  By deafult non-persistent semaphores reside
  # in /tmp which is assumed to be cleaned at boot by the
  # operating system
  if $persistent {
    $semaphore = "${persistent_dir}/${title}"
  } else {
    $semaphore = "/tmp/puppet-semaphore-${title}"
  }

  exec { $name:
    command => $command,
    user    => $user,
    cwd     => $cwd,
    timeout => $timeout,
    creates => $semaphore,
    require => File[$persistent_dir],
  } ->

  file { $semaphore:
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

}
