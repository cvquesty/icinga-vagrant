# Class: apache
#
#   This class installs the apache server.
#
#   Copyright (C) 2013-present Icinga Development Team (http://www.icinga.org/)
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#   include apache
#
class apache {
  $apache = $::operatingsystem ? {
    /(Debian|Ubuntu)/ => 'apache2',
    /(RedHat|CentOS|Fedora)/ => 'httpd'
  }

  package { $apache:
    ensure => installed,
    alias  => 'apache',
  }

  exec { 'iptables-allow-http':
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    unless  => 'grep -Fxqe "-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT" /etc/sysconfig/iptables',
    command => 'lokkit --enabled --service=http',
  }

  service { $apache:
    ensure  => 'running',
    enable  => true,
    alias   => 'apache',
    require => [ Package['apache'], Exec['iptables-allow-http'] ],
  }
}
