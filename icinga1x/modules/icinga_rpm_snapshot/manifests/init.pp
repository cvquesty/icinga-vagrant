# Class: icinga-rpm-snapshot
#
#   Configure icinga rpm snaphot repository
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
#   include ['::icinga-rpm-snapshot']
#
class icinga_rpm_snapshot {
  yumrepo { 'icinga-rpm-snapshot':
    baseurl  => 'http://packages.icinga.org/epel/6/snapshot/',
    enabled  => '1',
    gpgcheck => '1',
    gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ICINGA',
    descr    => "Icinga Snapshot Packages for Enterprise Linux 6 - ${::architecture}",
  }

  file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-ICINGA':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:////vagrant/files/etc/pki/rpm-gpg/RPM-GPG-KEY-ICINGA',
  }

  icinga-rpm-snapshot::key { 'RPM-GPG-KEY-ICINGA':
    path   => '/etc/pki/rpm-gpg/RPM-GPG-KEY-ICINGA',
    before => Yumrepo['icinga-rpm-snapshot'],
  }
}

