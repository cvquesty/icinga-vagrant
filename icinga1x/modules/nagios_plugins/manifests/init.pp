# Class: nagios_plugins
#
#   Install nagios plugins
#
#   Copyright (C) 2013-present Icinga Development Team (http://www.icinga.org/)
#
# Parameters:
#
# Actions:
#
# Requires: epel
#
# Sample Usage:
#
#   include nagios_plugins
#

class nagios_plugins {
  include ['::epel']

  # nagios plugins from epel
  package { 'nagios-plugins-all':
    ensure  => 'installed',
    require => Class['epel'],
  }
}
