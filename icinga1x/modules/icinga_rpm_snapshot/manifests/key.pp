# Defined Type to import RPM Key
# inspired by https://github.com/stahnma/puppet-module-epel/blob/master/manifests/rpm_gpg_key.pp

define icinga_rpm_snapshot::key($path) {
  exec { "import-key-${name}":
    path      => '/bin:/usr/bin:/sbin:/usr/sbin',
    command   => "rpm --import ${path}",
    unless    => "rpm -q gpg-pubkey-$(echo $(gpg --throw-keyids < ${path}) | cut --characters=11-18 | tr '[A-Z]' '[a-z]')",
    require   => File[ $path ],
    logoutput => 'on_failure',
  }
}
