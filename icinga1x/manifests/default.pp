# Icinga Default Vagrant Installation Manifest
#
include ['::apache']
include ['::icinga']
include ['::icinga_classicui']
include ['::icinga_idoutils_libdbi_mysql']
include ['::icinga_web']
include ['::icinga_reports']
include ['::nagios_plugins']

package { 'vim-enhanced':
  ensure => 'installed',
}

# icinga demo docs at /icinga-demo
file { '/etc/httpd/conf.d/icinga-demo.conf':
  source  => 'puppet:////vagrant/files/etc/httpd/conf.d/icinga-demo.conf',
  require => [ Package['apache'], File['/usr/share/icinga-demo/htdocs/index.html'], Package['icinga-gui'], Package['icinga-web'] ],
  notify  => Service['apache'],
}

file { [ '/usr/share/icinga-demo', '/usr/share/icinga-demo/htdocs' ]:
  ensure => 'directory',
  owner  => 'root',
  group  => 'root',
  mode   => '0755',
}

file { '/usr/share/icinga-demo/htdocs/index.html':
  source => 'puppet:////vagrant/files/usr/share/icinga-demo/htdocs/index.html',
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
}

file { '/usr/share/icinga-demo/htdocs/icinga_wall.png':
  source => 'puppet:////vagrant/files/usr/share/icinga-demo/htdocs/icinga_wall.png',
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
}


file { '/etc/motd':
  source => 'puppet:////vagrant/files/etc/motd',
  owner  => 'root',
  group  => 'root',
}

user { 'vagrant':
  groups  => ['icinga', 'icingacmd'],
  require => [User['icinga'], Group['icingacmd']],
}
