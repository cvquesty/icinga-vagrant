# Class: icinga2_icinga_web
#
#   Install Icinga Web configuration for Icinga 2
#
#   Copyright (C) 2014-present Icinga Development Team (http://www.icinga.org/)
#
# Parameters:
#
# Actions:
#
# Requires: icinga_web, icinga2_ido-mysql, icinga2_ido_pgsql
#
# Sample Usage:
#
#   include icinga2_icinga_web
#

class icinga2_icinga_web {
  include ['::icinga_web']
  include ['::icinga2_ido_mysql']
  include ['::icinga2_ido_pgsql']

  exec { 'set-icinga2-cmd-pipe-path':
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    command => 'sed -i \'s/\/var\/spool\/icinga\/cmd\/icinga.cmd/\/var\/run\/icinga2\/cmd\/icinga2.cmd/g\' /etc/icinga-web/conf.d/access.xml',
    require => Package['icinga-web'],
  }

  exec { 'clear-config-cache':
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    command => '/usr/bin/icinga-web-clearcache',
    require => Exec['set-icinga2-cmd-pipe-path'],
  }
}
