# Main Icinga2 Parameters Manifest
#
class icinga2::params {

}

# Main Icinga2 Ido MySQL Parameters
#
class icinga2_ido_mysql::params {
  $ido_db_user   = 'icinga'
  $ido_db_pass   = 'icinga'
  $ido_db_name   = 'icinga'
  $ido_db_schema = '/usr/share/icinga2-ido-mysql/schema/mysql.sql'
}

# Main Icinga2 Ido PostGreSQL Parameters
#
class icinga2_ido_pgsql::params {
  $ido_db_user   = 'icinga'
  $ido_db_pass   = 'icinga'
  $ido_db_name   = 'icinga'
  $ido_db_schema = '/usr/share/icinga2-ido-pgsql/schema/pgsql.sql'
}
