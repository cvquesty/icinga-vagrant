# Default Build Manifest for Icinga2
#
include ['::icinga_rpm']
include ['::epel']
include ['::mysql::server']
include ['::icinga2']
include ['::icinga2_ido_mysql']
include ['::icingaweb2']
include ['::icingaweb2_internal_db_mysql']
include ['::monitoring_plugins']

####################################
# Webserver
####################################

class {'::apache':
  purge_configs => false,
  default_vhost => false,
}

class { '::apache::mod::php': }

apache::vhost { 'vagrant-demo.icinga.org':
  priority => '5',
  port     => '80',
  docroot  => '/var/www/html',
  rewrites => [
    {
      rewrite_rule => ['^/$ /icingaweb2 [NE,L,R=301]'],
    },
  ],
}

apache::vhost { 'vagrant-demo.icinga.org-ssl':
  priority   => 5,
  port       => '443',
  docroot    => '/var/www/html',
  ssl        => true,
  add_listen => false, #prevent duplicate listen entries
    rewrites => [
      {
        rewrite_rule => ['^/$ /icingaweb2 [NE,L,R=301]'],
      },
    ],
  }

include ['::php::cli']
include ['::php::mod_php5']

php::ini { '/etc/php.ini':
  display_errors    => 'On',
  memory_limit      => '256M',
  date_timezone     => 'Europe/Berlin',
  session_save_path => '/var/lib/php/session',
}

####################################
# Misc
####################################
# fix puppet warning.
# https://ask.puppetlabs.com/question/6640/warning-the-package-types-allow_virtual-parameter-will-be-changing-its-default-value-from-false-to-true-in-a-future-release/
if versioncmp($::puppetversion,'3.6.1') >= 0 {
  $allow_virtual_packages = hiera('allow_virtual_packages',false)
  Package {
    allow_virtual => $allow_virtual_packages,
  }
}

package { [ 'mailx', 'tree', 'gdb', 'git', 'bash-completion', 'screen', 'htop' ]:
  ensure  => 'installed',
  require => Class['epel'],
}

@user { 'vagrant':
  ensure => 'present',
}

User<| title == vagrant |>{
  groups  +> ['icinga', 'icingacmd'],
  require => Package['icinga2']
}

file { '/etc/motd':
  source => 'puppet:////vagrant/files/etc/motd',
  owner  => 'root',
  group  => 'root',
}

file { '/etc/profile.d/env.sh':
  source => 'puppet:////vagrant/files/etc/profile.d/env.sh',
}

# Required by vim-icinga2
class { '::vim':
  opt_bg_shading => 'light',
}

####################################
# Icinga 2 General
####################################

file { '/etc/icinga2':
  ensure  => 'directory',
  require => Package['icinga2'],
}

file { '/etc/icinga2/icinga2.conf':
  owner   => 'icinga',
  group   => 'icinga',
  source  => 'puppet:////vagrant/files/etc/icinga2/icinga2.conf',
  require => File['/etc/icinga2'],
  notify  => Service['icinga2'],
}

file { '/etc/icinga2/zones.conf':
  owner   => 'icinga',
  group   => 'icinga',
  source  => 'puppet:////vagrant/files/etc/icinga2/zones.conf',
  require => Package['icinga2'],
  notify  => Service['icinga2'],
}

# enable the command pipe
icinga2::feature { 'command': }

file { '/etc/icinga2/conf.d/hosts.conf':
  owner   => 'icinga',
  group   => 'icinga',
  source  => 'puppet:////vagrant/files/etc/icinga2/conf.d/hosts.conf',
  require => Package['icinga2'],
  notify  => Service['icinga2'],
}

file { '/etc/icinga2/conf.d/additional_services.conf':
  owner   => 'icinga',
  group   => 'icinga',
  source  => 'puppet:////vagrant/files/etc/icinga2/conf.d/additional_services.conf',
  require => Package['icinga2'],
  notify  => Service['icinga2'],
}

# api
exec { 'enable-icinga2-api':
  path    => '/bin:/usr/bin:/sbin:/usr/sbin',
  command => 'icinga2 api setup',
  require => Package['icinga2'],
  notify  => Service['icinga2'],
}

file { '/etc/icinga2/conf.d/api-users.conf':
  owner   => 'icinga',
  group   => 'icinga',
  content => template('icinga2/api-users.conf.erb'),
  require => [ Package['icinga2'], Exec['enable-icinga2-api'] ],
  notify  => Service['icinga2'],
}

####################################
# Icinga Web 2
####################################

# user-defined preferences (using the iframe module)
file { '/etc/icingaweb2/preferences':
  ensure  => 'directory',
  owner   => 'root',
  group   => 'icingaweb2',
  mode    => '2770',
  require => Package['icingaweb2'],
}

file { '/etc/icingaweb2/preferences/icingaadmin':
  ensure  => 'directory',
  recurse => true,
  owner   => 'root',
  group   => 'icingaweb2',
  mode    => '2770',
  source  => 'puppet:////vagrant/files/etc/icingaweb2/preferences/icingaadmin',
  require => [ package['icingaweb2'], File['/etc/icingaweb2/preferences'] ],
}

# user-defined dashboards for the default 'icingaadmin' user
file { '/etc/icingaweb2/dashboards':
  ensure  => 'directory',
  owner   => 'root',
  group   => 'icingaweb2',
  mode    => '2770',
  require => Package['icingaweb2'],
}

file { '/etc/icingaweb2/dashboards/icingaadmin':
  ensure  => 'directory',
  recurse => true,
  owner   => 'root',
  group   => 'icingaweb2',
  mode    => '2770',
  source  => 'puppet:////vagrant/files/etc/icingaweb2/dashboards/icingaadmin',
  require => [ Package['icingaweb2'], File['/etc/icingaweb2/dashboards'] ],
}

# present icinga2 in icingaweb2's module documentation
file { '/usr/share/icingaweb2/modules/icinga2':
  ensure  => 'directory',
  require => Package['icingaweb2'],
}

file { '/usr/share/icingaweb2/modules/icinga2/doc':
  ensure  => 'link',
  target  => '/usr/share/doc/icinga2/markdown',
  require => [ Package['icinga2'], Package['icingaweb2'], File['/usr/share/icingaweb2/modules/icinga2'] ],
}

file { '/etc/icingaweb2/enabledModules/icinga2':
  ensure  => 'link',
  target  => '/usr/share/icingaweb2/modules/icinga2',
  require => File['/etc/icingaweb2/enabledModules'],
}

####################################
# PNP
####################################

include ['::pnp4nagios']

icinga2::feature { 'perfdata': }

icingaweb2::module { 'pnp':
  builtin => false,
}

# override the default httpd config w/o basic auth

file { 'pnp4nagios_httpd_config':
  name    => '/etc/httpd/conf.d/pnp4nagios.conf',
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => template('pnp4nagios/pnp4nagios.conf.erb'),
  require => Class['apache'],
  notify  => Class['apache::service'],
}

####################################
# BP
####################################

file { 'check_mysql_health':
  name    => '/usr/lib64/nagios/plugins/check_mysql_health',
  owner   => 'root',
  group   => 'root',
  mode    => '0755',
  source  => 'puppet:////vagrant/files/usr/lib64/nagios/plugins/check_mysql_health',
  require => Class['monitoring_plugins'],
}

file { '/etc/icinga2/bp':
  ensure  => directory,
  recurse => true,
  owner   => 'icinga',
  group   => 'icinga',
  source  => 'puppet:////vagrant/files/etc/icinga2/bp',
  require => File['/etc/icinga2/icinga2.conf'],
  notify  => Service['icinga2'],
}

icingaweb2::module { 'businessprocess':
  builtin => false,
}

file { '/etc/icingaweb2/modules/businessprocess':
  ensure  => 'directory',
  recurse => true,
  owner   => 'root',
  group   => 'icingaweb2',
  mode    => '2770',
  source  => 'puppet:////vagrant/files/etc/icingaweb2/modules/businessprocess',
  require => Package['icingaweb2'],
}

####################################
# GenericTTS
####################################

icingaweb2::module { 'generictts':
  builtin => false,
}

file { '/etc/icingaweb2/modules/generictts':
  ensure  => 'directory',
  recurse => true,
  owner   => 'root',
  group   => 'icingaweb2',
  mode    => '2770',
  source  => 'puppet:////vagrant/files/etc/icingaweb2/modules/generictts',
  require => Package['icingaweb2'],
}

file { 'feed-tts-comments':
  name   => '/usr/local/bin/feed-tts-comments',
  owner  => 'root',
  group  => 'root',
  mode   => '0755',
  source => 'puppet:////vagrant/files/usr/local/bin/feed-tts-comments',
}

exec { 'feed-tts-comments-host':
  path    => '/bin:/usr/bin:/sbin:/usr/sbin',
  command => '/usr/local/bin/feed-tts-comments',
  require => [ File['feed-tts-comments'], Service['icinga2'] ],
}

####################################
# NagVis
####################################

include ['::nagvis']

icingaweb2::module { 'nagvis':
  builtin => false,
}

file { 'nagvis-link-css-styles':
  ensure  => 'link',
  path    => '/usr/local/nagvis/share/userfiles/styles/icingaweb-nagvis-integration.css',
  target  => '/usr/share/icingaweb2/modules/nagvis/public/css/icingaweb-nagvis-integration.css',
  require => [ Class['nagvis'], File["${::icingaweb2::config_dir}/enabledModules/nagvis"] ],
}

file { 'nagvis-core-functions-index.php':
  ensure  => 'present',
  path    => '/usr/local/nagvis/share/server/core/functions/index.php',
  source  => 'puppet:////vagrant/files/usr/local/nagvis/share/server/core/functions/index.php',
  mode    => '0644',
  require => Class['nagvis'],
}

file { 'nagvis-map-icinga2':
  ensure  => 'present',
  path    => '/usr/local/nagvis/etc/maps/icinga2.cfg',
  source  => 'puppet:////vagrant/files/usr/local/nagvis/etc/maps/icinga2.cfg',
  mode    => '0644',
  require => Class['nagvis'],
}
####################################
# Director
####################################

icinga2::feature { 'api': }

icingaweb2::module { 'director':
  builtin => false, } ->
exec { 'fix-binary-blog-bug-zend-655':
  path    => '/bin:/usr/bin:/sbin:/usr/sbin',
  command => 'sed -i \'s/$value = addcslashes/\/\/$value = addcslashes/\' /usr/share/php/Zend/Db/Adapter/Pdo/Abstract.php' } ->

# ship box specific director module config
file {'/etc/icingaweb2/modules/director':
  ensure  => 'directory',
  owner   => 'root',
  group   => 'icingaweb2',
  mode    => '2770',
  require => [ package['icingaweb2'], File['/etc/icingaweb2/modules'] ], } ->

file { '/etc/icingaweb2/modules/director/config.ini':
  ensure  => 'file',
  owner   => 'root',
  group   => 'icingaweb2',
  mode    => '2770',
  source  => 'puppet:////vagrant/files/etc/icingaweb2/modules/director/config.ini',
  require => File['/etc/icingaweb2/modules/director'] }->

exec { 'create-mysql-icingaweb2-director-db':
  path    => '/bin:/usr/bin:/sbin:/usr/sbin',
  unless  => 'mysql -udirector -pdirector director',
  command => 'mysql -uroot -e "CREATE DATABASE director; GRANT ALL ON director.* TO director@localhost IDENTIFIED BY \'director\';"',
  require => Service['mariadb'], }->

exec { 'Icinga Director DB migration':
  path    => '/usr/local/bin:/usr/bin:/bin',
  command => 'icingacli director migration run',
  onlyif  => 'icingacli director migration pending',
  require => Package['icingacli'], }->

file { '/etc/icingaweb2/modules/director/kickstart.ini':
  ensure  => 'file',
  owner   => 'root',
  group   => 'icingaweb2',
  mode    => '2770',
  source  => 'puppet:////vagrant/files/etc/icingaweb2/modules/director/kickstart.ini',
  require => File['/etc/icingaweb2/modules/director'], }->

exec { 'Icinga Director Kickstart':
  path    => '/usr/local/bin:/usr/bin:/bin',
  command => 'icingacli director kickstart run',
  onlyif  => 'icingacli director kickstart required',
  require => Service['icinga2'],
}

####################################
# Dashing
####################################

package { [ 'rubygems', 'rubygem-bundler',
            'ruby-devel', 'openssl', 'gcc-c++',
            'make', 'nodejs', 'v8',
          ]:
  ensure  => 'installed',
  require => Class['epel'], }->

file { 'gemrc':
  name   => '/etc/gemrc',
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
  source => 'puppet:////vagrant/files/etc/gemrc', }->

vcsrepo { '/usr/share/dashing-icinga2':
  ensure   => 'present',
  path     => '/usr/share/dashing-icinga2',
  provider => 'git',
  revision => 'master',
  source   => 'https://github.com/Icinga/dashing-icinga2.git',
  force    => true,
  require  => Package['git'], }->

exec { 'dashing-bundle-install':
  path    => '/bin:/usr/bin:/sbin:/usr/sbin',
  command => 'cd /usr/share/dashing-icinga2 && bundle install --jobs 4 --system',
  timeout => '1800' }->

file { '/usr/local/bin/restart-dashing':
  ensure => 'link',
  force  => true,
  target => '/usr/share/dashing-icinga2/restart-dashing', } ->

exec { 'dashing-start':
  path    => '/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin',
  command => '/usr/share/dashing-icinga2/restart-dashing',
  require => Service['icinga2'],
}

####################################
# Graphite
####################################

icinga2::feature { 'graphite': }

# 0.9.14 requires pytz: https://github.com/graphite-project/graphite-web/issues/1019
package { 'pytz':
  ensure  => 'installed',
  require => Class['epel'],
}

# avoid a bug in the pip provider
# https://github.com/echocat/puppet-graphite/issues/180
file { 'pip-symlink':
  ensure => 'link',
  path   => '/usr/bin/pip-python',
  target => '/usr/bin/pip',
  before => Class['graphite'],
}

file { '/opt/graphite':
  ensure => 'directory', }->

apache::vhost { 'graphite.localdomain':
  port                        => '8003',
  docroot                     => '/opt/graphite/webapp',
  wsgi_application_group      => '%{GLOBAL}',
  wsgi_daemon_process         => 'graphite',
  wsgi_daemon_process_options => {
    processes          => '5',
    threads            => '5',
    display-name       => '%{GROUP}',
    inactivity-timeout => '120',
  },
  wsgi_import_script          => '/opt/graphite/conf/graphite_wsgi.py',
  wsgi_import_script_options  => {
    process-group     => 'graphite',
    application-group => '%{GLOBAL}',
  },
  wsgi_process_group          => 'graphite',
  wsgi_script_aliases         => {
    '/' => '/opt/graphite/conf/graphite_wsgi.py',
  },
  headers                     => [
    'set Access-Control-Allow-Origin "*"',
    'set Access-Control-Allow-Methods "GET, OPTIONS, POST"',
    'set Access-Control-Allow-Headers "origin, authorization, accept"',
  ],
  directories                 => [{
    path => '/media/',
  } ] }->

class { '::graphite':
  gr_apache_24            => true,
  gr_web_server           => 'none',
  gr_web_user             => 'apache',
  gr_web_group            => 'apache',
  gr_disable_webapp_cache => true,
  secret_key              => 'ICINGA2ROCKS',
  gr_graphite_ver         => '0.9.14',
  gr_carbon_ver           => '0.9.14',
  gr_whisper_ver          => '0.9.14',
  gr_twisted_ver          => '13.2.0',
  gr_timezone             => 'Europe/Berlin',
}

# icingaweb2 module
icingaweb2::module { 'graphite':
  builtin => false,
}

# ship box specific graphite module config
file {'/etc/icingaweb2/modules/graphite':
  ensure  => 'directory',
  owner   => 'root',
  group   => 'icingaweb2',
  mode    => '2770',
  require => [ Package['icingaweb2'], File['/etc/icingaweb2/modules'] ], } ->

file { '/etc/icingaweb2/modules/graphite/templates':
  ensure => 'link',
  force  => true,
  target => '/usr/share/icingaweb2/modules/graphite/sample-config/icinga2/templates' } ->

file { '/etc/icingaweb2/modules/graphite/config.ini':
  ensure  => 'file',
  owner   => 'root',
  group   => 'icingaweb2',
  mode    => '2770',
  source  => 'puppet:////vagrant/files/etc/icingaweb2/modules/graphite/config.ini',
  require => File['/etc/icingaweb2/modules/graphite'],
}


####################################
# Grafana
####################################

# https://github.com/bfraser/puppet-grafana
class { '::grafana':
  version       => '3.0.4',
  rpm_iteration => '1464167696',
  cfg           => {
    app_mode => 'production',
    server   => {
      http_port => '8004',
    },

  users      => {
    allow_sign_up => false,
  },

  security   => {
      admin_user     => 'admin',
      admin_password => 'admin',
    },
  },
} ->

# there are no static config files for data sources in grafana2
# https://github.com/grafana/grafana/issues/1789
file { 'grafana-setup':
  name   => '/usr/local/bin/grafana-setup',
  owner  => 'root',
  group  => 'root',
  mode   => '0755',
  source => 'puppet:////vagrant/files/usr/local/bin/grafana-setup', } ->

file { 'grafana-dashboard-icinga2':
  name   => '/etc/icinga2/grafana-dashboard-icinga2.json',
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
  source => 'puppet:////vagrant/files/etc/icinga2/grafana-dashboard-icinga2.json',
}
->
exec { 'finish-grafana-setup':
  path    => '/bin:/usr/bin:/sbin:/usr/sbin',
  command => '/usr/local/bin/grafana-setup',
  require => [ Class['graphite'], Class['grafana::service'] ],
  notify  => Class['apache::service'],
}

####################################
# Clippy.js
####################################

vcsrepo { '/var/www/html/icinga2-api-examples':
  ensure   => 'present',
  path     => '/var/www/html/icinga2-api-examples',
  provider => 'git',
  revision => 'master',
  source   => 'https://github.com/Icinga/icinga2-api-examples.git',
  force    => true,
  require  => Package['git'],
}
