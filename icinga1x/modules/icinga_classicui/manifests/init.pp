# Class: icinga_classicui
#
#   Install Icinga Classic UI with Icinga 1.x configuration
#
#   Copyright (C) 2014-present Icinga Development Team (http://www.icinga.org/)
#
# Parameters:
#
# Actions:
#
# Requires: icinga_rpm_snapshot, icinga
#
# Sample Usage:
#
#   include ['::icinga_classicui']
#

class icinga_classicui {
  include ['::icinga_rpm_snapshot']
  include ['::icinga']

  package { 'icinga-gui':
    ensure => 'installed',
    alias  => 'icinga-gui',
  }

  # runtime users
  group { 'icingacmd':
    ensure => 'present',
  }

  user { 'icinga':
    ensure     => 'present',
    groups     => 'icingacmd',
    managehome => false,
  }

  user { 'apache':
    groups  => ['icingacmd', 'vagrant'],
    require => [ Class['apache'], Group['icingacmd'] ],
  }
}
