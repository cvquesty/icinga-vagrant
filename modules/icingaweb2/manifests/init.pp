# IcingaWeb2 Configuration manifest
#
class icingaweb2 (
  $config_dir           = $::icingaweb2::config_dir,
  $web_config_dir_mode  = $::icingaweb2::config_dir_mode,
  $web_config_file_mode = $::icingaweb2::config_file_mode,
  $config_user          = $::icingaweb2::config_user,
  $config_group         = $::icingaweb2::config_group,
  $web_module_dir       = $::icingaweb2::web_module_dir,
) inherits icingaweb2::params {

  validate_string($config_dir)
  validate_string($web_module_dir)

  package { 'icingaweb2':
    ensure  => latest,
    require => [ Package['httpd'], Class['icinga_rpm'], Class['epel'], Package['php-ZendFramework'], Package['php-ZendFramework-Db-Adapter-Pdo-Mysql'] ],
    alias   => 'icingaweb2',
    notify  => Class['Apache::Service'],
  }

  package { 'php-Icinga':
    ensure  => 'latest',
    require => [ Class['icinga_rpm'], Class['epel'], Package['php-ZendFramework'], Package['php-ZendFramework-Db-Adapter-Pdo-Mysql'] ],
    alias   => 'php-Icinga',
  }

  package { 'icingacli':
    ensure  => 'latest',
    require => [ Class['icinga_rpm'], Class['epel'], Package['php-ZendFramework'], Package['php-ZendFramework-Db-Adapter-Pdo-Mysql'] ],
    alias   => 'icingacli',
  }

  package { ['php-ZendFramework', 'php-ZendFramework-Db-Adapter-Pdo-Mysql']:
    ensure  => 'latest',
    require => Class['icinga_rpm'],
  }

  file { $config_dir:
    ensure  => 'directory',
    mode    => $web_config_dir_mode,
    owner   => $config_user,
    group   => $config_group,
    require => Package['icingaweb2'],
  }

  file { "${config_dir}/authentication.ini":
    mode    => $web_config_file_mode,
    owner   => $config_user,
    group   => $config_group,
    content => template('icingaweb2/authentication.ini.erb'),
  }

  file { "${config_dir}/config.ini":
    mode    => $web_config_file_mode,
    owner   => $config_user,
    group   => $config_group,
    content => template('icingaweb2/config.ini.erb'),
  }

  file { "${config_dir}/roles.ini":
    mode    => $web_config_file_mode,
    owner   => $config_user,
    group   => $config_group,
    content => template('icingaweb2/roles.ini.erb'),
  }

  file { "${config_dir}/resources.ini":
    mode    => $web_config_file_mode,
    owner   => $config_user,
    group   => $config_group,
    content => template('icingaweb2/resources.ini.erb'),
  }

  file { "${config_dir}/modules":
    ensure => 'directory',
    mode   => $web_config_dir_mode,
    owner  => $config_user,
    group  => $config_group,
  }

  file { "${config_dir}/enabledModules":
    ensure => 'directory',
    mode   => $web_config_dir_mode,
    owner  => $config_user,
    group  => $config_group,
  }

  file { "${config_dir}/modules/monitoring":
    ensure  => 'directory',
    mode    => $web_config_dir_mode,
    owner   => $config_user,
    group   => $config_group,
    require => File["${config_dir}/modules"],
  }

  file { "${config_dir}/modules/monitoring/backends.ini":
    mode    => $web_config_file_mode,
    owner   => $config_user,
    group   => $config_group,
    content => template('icingaweb2/modules/monitoring/backends.ini.erb'),
    require => File["${config_dir}/modules/monitoring"],
  }

  file {  "${config_dir}/modules/monitoring/config.ini":
    mode    => $web_config_file_mode,
    owner   => $config_user,
    group   => $config_group,
    content => template('icingaweb2/modules/monitoring/config.ini.erb'),
    require => File["${config_dir}/modules/monitoring"],
  }

  file {  "${config_dir}/modules/monitoring/commandtransports.ini":
    mode    => $web_config_file_mode,
    owner   => $config_user,
    group   => $config_group,
    content => template('icingaweb2/modules/monitoring/commandtransports.ini.erb'),
    require => File["${config_dir}/modules/monitoring"],
  }

  file { $web_module_dir:
    ensure  => 'directory',
    require => Package['icingaweb2'],
  }

  icingaweb2::module { [ 'doc', 'monitoring' ]:
    builtin   => true,
  }
}

# Internal IcingaWeb2 MySQL DB Configuration Class
#
class icingaweb2_internal_db_mysql {

  exec { 'create-mysql-icingaweb2-db':
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    unless  => 'mysql -uicingaweb2 -picingaweb2 icingaweb2',
    command => 'mysql -uroot -e "CREATE DATABASE icingaweb2; GRANT ALL ON icingaweb2.* TO icingaweb2@localhost IDENTIFIED BY \'icingaweb2\';"',
    require => Service['mariadb'],
  }

  exec { 'populate-icingaweb2-mysql-db':
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    unless  => 'mysql -uicingaweb2 -picingaweb2 icingaweb2 -e "SELECT * FROM icingaweb_user;" &> /dev/null',
    command => 'mysql -uicingaweb2 -picingaweb2 icingaweb2 < /usr/share/doc/icingaweb2/schema/mysql.schema.sql; mysql -uicingaweb2 -picingaweb2 icingaweb2 -e "INSERT INTO icingaweb_user (name, active, password_hash) VALUES (\'icingaadmin\', 1, \'\$1\$iQSrnmO9\$T3NVTu0zBkfuim4lWNRmH.\');"',
    require => [ Exec['create-mysql-icingaweb2-db'], Package['icingaweb2'] ],
  }
}
