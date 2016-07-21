# IcingaWeb2 Parameters Manifest
#
class icingaweb2::params {
  $config_dir       = '/etc/icingaweb2'
  $config_dir_mode  = '2770'
  $config_file_mode = '0660'
  $config_user      = 'root'
  $config_group     = 'icingaweb2'
  $git_repo_base    = 'https://git.icinga.org/'
  $web_root_dir     = '/usr/share/icingaweb2'
  $web_module_dir   = "${web_root_dir}/modules/"
}

