# PNP4Nagios Service Control Manifest
#
class pnp4nagios::service {
  $ensure = $pnp4nagios::params::ensure ? {
    'present' => true,
    'absent'  => false,
    }

  file { '/etc/systemd/system/npcd.service':
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('pnp4nagios/npcd.service') } ->

  service { 'npcd':
    ensure     => $ensure,
    name       => 'npcd',
    provider   => 'systemd',
    enable     => $ensure,
    hasstatus  => true,
    hasrestart => true,
  }
}
