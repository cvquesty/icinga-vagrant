# Class: snmp
#
#   This class installs the snmp server and client software.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#   include snmp
#
class snmp {

  Exec { path => '/usr/bin' }

  package { 'net-snmp':
    ensure => 'installed',
  }

  package { 'net-snmp-perl':
    ensure => 'installed',
  }

  package { 'perl-Net-SNMP':
    ensure => 'installed',
  }

  service { 'snmpd':
    ensure  => 'running',
    enable  => true,
    require => Package['net-snmp'],
  }

  file { '/etc/snmp/snmpd.conf':
    content => template('snmp/snmpd.conf.erb'),
    require => Package['net-snmp'],
    notify  => Service['snmpd'],
  }
}
