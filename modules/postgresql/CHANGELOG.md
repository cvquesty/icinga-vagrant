## Supported Release 4.7.1
### Summary
This release contains some bugfixes and documentation updates.

#### Bugfixes
- (MODULES-3024) Quote database objects when creating databases.
- Properly escape case where password ends with '$'.
- Fixes password change when postgres is configure to non-standard port.
- Unpins concat dependency to be able to use concat 2.x.
- Workaround to fix installing on Amazon Linux.
- Fixes proper defaulting of `$service_provider` parameter.
- Fixes postgres server init script naming on Amazon Linux.
- Fixes service reload parameter on Arch Linux.
- Adds missing onlyif_function to sequence grant code.
- Fixes to the markdown of the README.

## Supported Release 4.7.0
### Summary
A release with a considerable amount of new features, including remote db support and several platform support updates. Various bugfixes including several to address warnings and a sizable README update.

#### Features
- Remote DB support - Connection-settings allows a hash of options that can be used when connecting to a remote DB.
- Debian 8 support.
- Updated systemd-override to support fedora and CentOS paths.
- Adds the ability to define the extension name separately from the title of the resource, which allows you to add the extension to more than one database.
- Added parameter to disable automatic service restarts on config changes.
- Ubuntu 15.10 compatibility.
- OpenBSD version is now 9.4.
- Added .gitattributes to maintain line endings for .sh and .rb files.
- Adds default postgis version for 9.5.
- Allows float postgresql_conf values.
- Schedule apt update after install of repo.

#### Bugfixes
- Fixed systemd-override for RedHat systems with unmanaged Yum repos.
- Removed inherits postgresql::params.
- Multi-node tests are now not ran by default.
- Change apt::pin to apt_postgresql_org to prevent error message.
- Removed syntax error near UTF8.
- Removal of extra blanks and backslashes in README.
- Double quotes now used around database name to prevent syntax error.
- Removes ruby 1.8.7 and puppet 2.7 from travis-ci jobs.
- Fixed paths to work on Amazon Linux.
- Fixed quotes around locale options.
- Huge README update.
- Update to use current msync configs.
- Fixes postgresql::server acceptance test descriptions.

## Supported Release 4.6.1
###Summary

Small release for support of newer PE versions. This increments the version of PE in the metadata.json file.

## 2015-09-01 - Supported Release 4.6.0
### Summary
This release adds a proxy feature for yum, Postgis improvements, and decoupling pg_hba_rule from postgresql::server.

#### Features
- Support setting a proxy for yum operations
- Allow for undefined PostGIS version
- Decouple pg_hba_rule from postgresql::server

#### Bugfixes
- Fix postgis default package name on RedHat

## 2015-07-27 - Supported Release 4.5.0
### Summary
This release adds sequence grants, some postgresql 9.4 fixes, and `onlyif` to
the psql resource.

### Features
- Add `onlyif` parameter to `postgresql_psql`
- Add unsupported compatibility with Ubuntu 15.04
- Add unsupported compatibility with SLES 11/12 and OpenSuSE 13.2
- Add `postgresql::server::grant::onlyif_exists` attribute
- Add `postgresql::server::table_grant::onlyif_exists` attribute
- Add granting permissions on sequences

### Bugfixes
- Added docs for `postgresql::server::grant`
- Fix `pg_hba_conf_defaults => false` to not disable ipv4/ipv6 acls
- Fix 9.4 for `postgresql::server::pg_hba_rule`

## 2015-07-07 - Supported Release 4.4.2
### Summary
This release fixes a bug introduced in 4.4.0.

#### Bugfixes
- Fixes `withenv` execution under Puppet 2.7. (MODULES-2185)

## 2015-07-01 - Supported Release 4.4.1
### Summary
This release fixes RHEL 7 & Fedora with manage_package_repo switched on.

#### Bugfixes
- Ensure manage_package_repo variable is in scope for systemd-override file for RHEL7

## 2015-06-30 - Supported Release 4.4.0
### Summary
This release has several new features, bugfixes, and test improvements.

#### Features
- Adds a resource to manage recovery.conf.
- Adds a parameter that allows the specification of a validate connection script in `postgresql::client`.
- Adds support for plpython package management.
- Adds support for postgresql-docs management.
- Adds ability to make `postgresql::server::schema` titles unique. (MODULES-2049)
- Updates puppetlabs-apt module dependency to support version 2.1.0.

#### Bugfixes
- Fix `postgresql_psql` parameter ordering to work on OpenBSD with Future Parser
- Fix setting postgres role password (MODULES-1869)
- Fix execution command with puppet <3.4 (MODULES-1923)
- Fix Puppet.newtype deprecation warning (MODULES-2007)
- Fix systemd override for manage_repo package versions
- Fix Copy snakeoil certificate and key instead of symlinking

#### Test Improvements
- Allows setting BEAKER and BEAKER_RSPEC versions via environment variables.
- Enables Unit testing on Travis CI with Puppet 4.
- Cleans up spec_helper_acceptance.rb to use new puppet_install_helper gem.

## 2015-03-24 - Supported Release 4.3.0
### Summary
This release fixes compatibility with Puppet 4 and removes opportunities for local users to view the postgresql password. It also adds a new custom resource to aid in managing replication.

#### Features
- Add `postgresql::server::logdir` parameter to manage the logdir
- Add `environment` parameter to `postgresql_psql`
- Add `postgresql_replication_slot` custom resource

#### Bugfixes
- Fix for Puppet 4
- Don't print postgresql\_psql password in command
- Allow `postgresql::validate_db_connection` for more than one host+port+database combo
- Fix service command on Debian 8 and up
- Fix `postgresql::server::extension` to work with custom user/group/port
- Fix `postgresql::server::initdb` to work with custom user/group/port
- Fix changing template1 encoding
- Fix default `postgresql::server::grant::object_name` value
- Fix idempotency of granting all tables in schema with `puppet::server::grant`
- Fix lint warnings
- Fix apt key to use 40 character key and bump puppetlabs-apt to >= 1.8.0 < 2.0.0


##2015-03-10 - Supported Release 4.2.0
###Summary

This release has several new features including support for server extensions, improved grant support, and a number of bugfixes.

####Features
- Changes to support OpenBSD
- Add `service_reload` parameter to `postgresql::server`
- Add `comment` parameter to `postgresql::server::database` (MODULES-1153)
- Add `postgresql::server::extension` defined type
- Add postgresql versions for utopic and jessie
- Update `postgresql::server::grant` to support 'GRANT SCHEMA' and 'ALL TABLES IN SCHEMA'

####Bugfixes
- Lint cleanup
- Remove outdated upgrade info from README
- Use correct TCP port when checking password
- Create role before database
- Fix template1 encoding on Debian
- Require server package before user permissions
- Fix `service_status` default for FreeBSD to allow PostgreSQL to start the first run
- Fix invalid US-ASCII byte sequence in `postgresql::server::grant` comments
- Reverted to default behavior for Debian systems as `pg_config` should not be overwritten (MODULES-1485)

##2014-11-04 - Supported Release 4.1.0
###Summary

This release adds the ability to change the PGDATA directory, and also includes documentation and test updates, future parser support, and a few other new features.

####Features
- Future parser support
- Documentation updates
- Test updates
- Add a link from `/etc/sysconfig/pgsql/postgresql-${version}` to `/etc/sysconfig/pgsql/postgresql` to support init scripts from the postgresql.org repo
- Add support for changing the PGDATA directory
- Set default versions for Fedora 21 and FreeBSD

##2014-09-03 - Supported Release 4.0.0
###Summary

This release removes the uninstall ability from the module, removes the firewall
management, overhauls all of the acceptance testing, as well as adds better
support for SuSE and Fedora.

###Backwards Incompatible changes.

- Uninstall code removal.
- Firewall management for Postgres.
- Set manage_pg_ident_conf to true.

####Uninstallation removal

We rely heavily on the ability to uninstall and reinstall postgres throughout
our testing code, testing features like "can I move from the distribution
packages to the upstream packages through the module" and over time we've
learnt that the uninstall code simply doesn't work a lot of the time.  It
leaves traces of postgres behind or fails to remove certain packages on Ubuntu,
and generally causes bits to be left on your system that you didn't expect.

When we then reinstall things fail because it's not a true clean slate, and
this causes us enormous problems during test.  We've spent weeks and months
working on these tests and they simply don't hold up well across the full range
of PE platforms.

Due to all these problems we've decided to take a stance on uninstalling in
general.  We feel that in 2014 it's completely reasonable and normal to have a
good provisioning pipeline combined with your configuration management and the
"correct" way to uninstall a fully installed service like postgresql is to
simply reprovision the server without it in the first place.  As a general rule
this is how I personally like to work and I think is a good practice.

####I'm not OK with this!

We understand that there are environments and situations in which it's not easy
to do that.  What if you accidently deployed Postgres on 100,000 nodes?  In the
future we're going to take a look at building some example 'profiles' to be
found under examples/ within this module that can uninstall postgres on popular
platforms.  These can be modified and used in your specific case to uninstall
postgresql.  They will be much more brute force and reliant on deleting entire
directories and require you to do more work up front in specifying where things
are installed but we think it'll prove to be a much cleaner mechanism for this
kind of thing rather than trying to weave it into the main module logic itself.

####Features
- Removal of uninstall.
- Removal of firewall management.
- Tests ported to rspec3.
- Acceptance tests rewritten.
- Add a defined type for creating database schemas.
- Add a pg_ident_rule defined type.
- Set manage_pg_ident_conf to true.
- Manage pg_ident.conf by default.
- Improve selinux support for tablespace.
- Remove deprecation warnings.
- Support changing PGDATA on RedHat.
- Add SLES 11 support.

####Bugfixes
- Link pg_config binary into /usr/bin.
- Fix fedora support by using systemd.
- Initdb should create xlogdir if set.

##2014-08-27 - Supported Release 3.4.3
###Summary

This release fixes Ubuntu 10.04 with Facter 2.2.

####Features
####Bugfixes
- Use a regular expression to match the major OS version on Ubuntu.

##2014-07-31 - Supported Release 3.4.2
###Summary

This release fixes recent Fedora versions.

####Features
####Bugfixes
- Fix Fedora.

##2014-07-15 - Supported Release 3.4.1
###Summary

This release merely updates metadata.json so the module can be uninstalled and
upgraded via the puppet module command.

##2014-04-14 - Supported Release 3.4.0
###Summary

This feature rolls up several important features, the biggest being PostGIS
handling and allowing `port` to be set on postgresql::server in order to
change the port that Postgres listens on.  We've added support for RHEL7
and Ubuntu 14.04, as well as allowing you to manage the service via
`service_ensure` finally.

####Features
- Added `perl_package_name` for installing bindings.
- Added `service_ensure` for allowing control of services.
- Added `postgis_version` and postgis class for installing postgis.
- Added `port` for selecting the port Postgres runs on.
- Add support for RHEL7 and Ubuntu 14.04.
- Add `default_db` to postgresql::server::database.
- Widen the selection of unquoted parameters in postgresql_conf{}
- Require the service within postgresql::server::reload for RHEL7.
- Add `inherit` to postgresql::server::role.

####Bugfixes

##2014-03-04 - Supported Release 3.3.3
###Summary

This is a supported release.  This release removes a testing symlink that can
cause trouble on systems where /var is on a seperate filesystem from the
modulepath.

####Features
####Bugfixes
####Known Bugs
* SLES is not supported.

##2014-03-04 - Supported Release 3.3.2
###Summary
This is a supported release. It fixes a problem with updating passwords on postgresql.org distributed versions of PostgreSQL.

####Bugfixes
- Correct psql path when setting password on custom versions.
- Documentation updates
- Test updates

####Known Bugs
* SLES is not supported.


##2014-02-12 - Version 3.3.1
####Bugfix:
- Allow dynamic rubygems host


##2014-01-28 - Version 3.3.0

###Summary

This release rolls up a bunch of bugfixes our users have found and fixed for
us over the last few months.  This improves things for 9.1 users, and makes
this module usable on FreeBSD.

This release is dedicated to 'bma', who's suffering with Puppet 3.4.1 issues
thanks to Puppet::Util::SUIDManager.run_and_capture.

####Features
 - Add lc_ config entry settings
 - Can pass template at database creation.
 - Add FreeBSD support.
 - Add support for customer `xlogdir` parameter.
 - Switch tests from rspec-system to beaker.  (This isn't really a feature)

####Bugfixes
 - Properly fix the deprecated Puppet::Util::SUIDManager.run_and_capture errors.
 - Fix NOREPLICATION option for Postgres 9.1
 - Wrong parameter name: manage_pg_conf -> manage_pg_hba_conf
 - Add $postgresql::server::client_package_name, referred to by install.pp
 - Add missing service_provider/service_name descriptions in ::globals.
 - Fix several smaller typos/issues throughout.
 - Exec['postgresql_initdb'] needs to be done after $datadir exists
 - Prevent defined resources from floating in the catalog.
 - Fix granting all privileges on a table.
 - Add some missing privileges.
 - Remove deprecated and unused concat::fragment parameters.


##2013-11-05 - Version 3.2.0

###Summary

Add's support for Ubuntu 13.10 (and 14.04) as well as x, y, z.

####Features
- Add versions for Ubuntu 13.10 and 14.04.
- Use default_database in validate_db_connection instead of a hardcoded
'postgres'
- Add globals/params layering for default_database.
- Allow specification of default database name.

####Bugs
- Fixes to the README.


##2013-10-25 - Version 3.1.0

###Summary

This is a minor feature and bug fix release.

Firstly, the postgresql_psql type now includes a new parameter `search_path` which is equivalent to using `set search_path` which allows you to change the default schema search path.

The default version of Fedora 17 has now been added, so that Fedora 17 users can enjoy the module.

And finally we've extended the capabilities of the defined type postgresql::validate_db_connection so that now it can handle retrying and sleeping between retries. This feature has been monopolized to fix a bug we were seeing with startup race conditions, but it can also be used by remote systems to 'wait' for PostgreSQL to start before their Puppet run continues.

####Features
- Defined $default_version for Fedora 17 (Bret Comnes)
- add search_path attribute to postgresql_psql resource (Jeremy Kitchen)
- (GH-198) Add wait and retry capability to validate_db_connection (Ken Barber)

####Bugs
- enabling defined postgres user password without resetting on every puppet run (jonoterc)
- periods are valid in configuration variables also (Jeremy Kitchen)
- Add zero length string to join() function (Jarl Stefansson)
- add require of install to reload class (cdenneen)
- (GH-198) Fix race condition on postgresql startup (Ken Barber)
- Remove concat::setup for include in preparation for the next concat release (Ken Barber)


##2013-10-14 - Version 3.0.0

Final release of 3.0, enjoy!


##2013-10-14 - Version 3.0.0-rc3

###Summary

Add a parameter to unmanage pg_hba.conf to fix a regression from 2.5, as well
as allowing owner to be passed into x.

####Features
- `manage_pg_hba_conf` parameter added to control pg_hba.conf management.
- `owner` parameter added to server::db.


##2013-10-09 - Version 3.0.0-rc2

###Summary

A few bugfixes have been found since -rc1.

####Fixes
- Special case for $datadir on Amazon
- Fix documentation about username/password for the postgresql_hash function


##2013-10-01 - Version 3.0.0-rc1

###Summary

Version 3 was a major rewrite to fix some internal dependency issues, and to
make the new Public API more clear. As a consequence a lot of things have
changed for version 3 and older revisions that we will try to outline here.

(NOTE:  The format of this CHANGELOG differs to normal in an attempt to
explain the scope of changes)

* Server specific objects now moved under `postgresql::server::` namespace:

To restructure server specific elements under the `postgresql::server::`
namespaces the following objects were renamed as such:

`postgresql::database`       -> `postgresql::server::database`
`postgresql::database_grant` -> `postgresql::server::database_grant`
`postgresql::db`             -> `postgresql::server::db`
`postgresql::grant`          -> `postgresql::server::grant`
`postgresql::pg_hba_rule`    -> `postgresql::server::pg_hba_rule`
`postgresql::plperl`         -> `postgresql::server::plperl`
`postgresql::contrib`        -> `postgresql::server::contrib`
`postgresql::role`           -> `postgresql::server::role`
`postgresql::table_grant`    -> `postgresql::server::table_grant`
`postgresql::tablespace`     -> `postgresql::server::tablespace`

* New `postgresql::server::config_entry` resource for managing configuration:

Previously we used the `file_line` resource to modify `postgresql.conf`. This
new revision now adds a new resource named `postgresql::server::config_entry`
for managing this file. For example:

```puppet
    postgresql::server::config_entry { 'check_function_bodies':
      value => 'off',
    }
```

If you were using `file_line` for this purpose, you should change to this new
methodology.

* `postgresql_puppet_extras.conf` has been removed:

Now that we have a methodology for managing `postgresql.conf`, and due to
concerns over the file management methodology using an `exec { 'touch ...': }`
as a way to create an empty file the existing postgresql\_puppet\_extras.conf
file is no longer managed by this module.

If you wish to recreate this methodology yourself, use this pattern:

```puppet
    class { 'postgresql::server': }

    $extras = "/tmp/include.conf"

    file { $extras:
      content => 'max_connections = 123',
      notify  => Class['postgresql::server::service'],
    }->
    postgresql::server::config_entry { 'include':
      value   => $extras,
    }
```

* All uses of the parameter `charset` changed to `encoding`:

Since PostgreSQL uses the terminology `encoding` not `charset` the parameter
has been made consisent across all classes and resources.

* The `postgresql` base class is no longer how you set globals:

The old global override pattern was less then optimal so it has been fixed,
however we decided to demark this properly by specifying these overrides in
the class `postgresql::global`. Consult the documentation for this class now
to see what options are available.

Also, some parameter elements have been moved between this and the
`postgresql::server` class where it made sense.

* `config_hash` parameter collapsed for the `postgresql::server` class:

Because the `config_hash` was really passing data through to what was in
effect an internal class (`postgresql::config`). And since we don't want this
kind of internal exposure the parameters were collapsed up into the
`postgresql::server` class directly.

* Lots of changes to 'private' or 'undocumented' classes:

If you were using these before, these have changed names. You should only use
what is documented in this README.md, and if you don't have what you need you
should raise a patch to add that feature to a public API. All internal classes
now have a comment at the top indicating them as private to make sure the
message is clear that they are not supported as Public API.

* `pg_hba_conf_defaults` parameter included to turn off default pg\_hba rules:

The defaults should be good enough for most cases (if not raise a bug) but if
you simply need an escape hatch, this setting will turn off the defaults. If
you want to do this, it may affect the rest of the module so make sure you
replace the rules with something that continues operation.

* `postgresql::database_user` has now been removed:

Use `postgresql::server::role` instead.

* `postgresql::psql` resource has now been removed:

Use `postgresql_psql` instead. In the future we may recreate this as a wrapper
to add extra capability, but it will not match the old behaviour.

* `postgresql_default_version` fact has now been removed:

It didn't make sense to have this logic in a fact any more, the logic has been
moved into `postgresql::params`.

* `ripienaar/concat` is no longer used, instead we use `puppetlabs/concat`:

The older concat module is now deprecated and moved into the
`puppetlabs/concat` namespace. Functionality is more or less identical, but
you may need to intervene during the installing of this package - as both use
the same `concat` namespace.

---
##2013-09-09 Release 2.5.0

###Summary

The focus of this release is primarily to capture the fixes done to the
types and providers to make sure refreshonly works properly and to set
the stage for the large scale refactoring work of 3.0.0.

####Features


####Bugfixes 
- Use boolean for refreshonly.
- Fix postgresql::plperl documentation.
- Add two missing parameters to config::beforeservice
- Style fixes


##2013-08-01 Release 2.4.1

###Summary

This minor bugfix release solves an idempotency issue when using plain text
passwords for the password_hash parameter for the postgresql::role defined
type. Without this, users would continually see resource changes everytime
your run Puppet.

####Bugfixes
- Alter role call not idempotent with cleartext passwords (Ken Barber)


##2013-07-19 Release 2.4.0

###Summary

This updates adds the ability to change permissions on tables, create template
databases from normal databases, manage PL-Perl's postgres package, and
disable the management of `pg_hba.conf`.

####Features
- Add `postgresql::table_grant` defined resource
- Add `postgresql::plperl` class
- Add `manage_pg_hba_conf` parameter to the `postgresql::config` class
- Add `istemplate` parameter to the `postgresql::database` define

####Bugfixes
- Update `postgresql::role` class to be able to update roles when modified
instead of only on creation.
- Update tests
- Fix documentation of `postgresql::database_grant`


##2.3.0

This feature release includes the following changes:

* Add a new parameter `owner` to the `database` type.  This can be used to
  grant ownership of a new database to a specific user.  (Bruno Harbulot)
* Add support for operating systems other than Debian/RedHat, as long as the
  user supplies custom values for all of the required paths, package names, etc.
  (Chris Price)
* Improved integration testing (Ken Barber)


##2.2.1

This release fixes a bug whereby one of our shell commands (psql) were not ran from a globally accessible directory. This was causing permission denied errors when the command attempted to change user without changing directory.

Users of previous versions might have seen this error:

    Error: Error executing SQL; psql returned 256: 'could not change directory to "/root"

This patch should correct that.

#### Detail Changes

* Set /tmp as default CWD for postgresql_psql


##2.2.0

This feature release introduces a number of new features and bug fixes.

First of all it includes a new class named `postgresql::python` which provides you with a convenient way of install the python Postgresql client libraries.

    class { 'postgresql::python':
    }

You are now able to use `postgresql::database_user` without having to specify a password_hash, useful for different authentication mechanisms that do not need passwords (ie. cert, local etc.).

We've also provided a lot more advanced custom parameters now for greater control of your Postgresql installation. Consult the class documentation for PuppetDB in the README.

This release in particular has largely been contributed by the community members below, a big thanks to one and all.

#### Detailed Changes

* Add support for psycopg installation (Flaper Fesp and Dan Prince)
* Added default PostgreSQL version for Ubuntu 13.04 (Kamil Szymanski)
* Add ability to create users without a password (Bruno Harbulot)
* Three Puppet 2.6 fixes (Dominic Cleal)
* Add explicit call to concat::setup when creating concat file (Dominic Cleal)
* Fix readme typo (Jordi Boggiano)
* Update postgres_default_version for Ubuntu (Kamil Szymanski)
* Allow to set connection for noew role (Kamil Szymanski)
* Fix pg_hba_rule for postgres local access (Kamil Szymanski)
* Fix versions for travis-ci (Ken Barber)
* Add replication support (Jordi Boggiano)
* Cleaned up and added unit tests (Ken Barber)
* Generalization to provide more flexability in postgresql configuration (Karel Brezina)
* Create dependent directory for sudoers so tests work on Centos 5 (Ken Barber)
* Allow SQL commands to be run against a specific DB (Carlos Villela)
* Drop trailing comma to support Puppet 2.6 (Michael Arnold)


##2.1.1


This release provides a bug fix for RHEL 5 and Centos 5 systems, or specifically systems using PostgreSQL 8.1 or older. On those systems one would have received the error:

    Error: Could not start Service[postgresqld]: Execution of ???/sbin/service postgresql start??? returned 1:

And the postgresql log entry:

    FATAL: unrecognized configuration parameter "include"

This bug is due to a new feature we had added in 2.1.0, whereby the `include` directive in `postgresql.conf` was not compatible. As a work-around we have added checks in our code to make sure systems running PostgreSQL 8.1 or older do not have this directive added.

#### Detailed Changes

2013-01-21 - Ken Barber <ken@bob.sh>
* Only install `include` directive and included file on PostgreSQL >= 8.2
* Add system tests for Centos 5


##2.1.0

This release is primarily a feature release, introducing some new helpful constructs to the module.

For starters, we've added the line `include 'postgresql_conf_extras.conf'` by default so extra parameters not managed by the module can be added by other tooling or by Puppet itself. This provides a useful escape-hatch for managing settings that are not currently managed by the module today.

We've added a new defined resource for managing your tablespace, so you can now create new tablespaces using the syntax:

    postgresql::tablespace { 'dbspace':
      location => '/srv/dbspace',
    }

We've added a locale parameter to the `postgresql` class, to provide a default. Also the parameter has been added to the `postgresql::database` and `postgresql::db` defined resources for changing the locale per database:

    postgresql::db { 'mydatabase':
      user     => 'myuser',
      password => 'mypassword',
      encoding => 'UTF8',
      locale   => 'en_NG',
    }

There is a new class for installing the necessary packages to provide the PostgreSQL JDBC client jars:

    class { 'postgresql::java': }

And we have a brand new defined resource for managing fine-grained rule sets within your pg_hba.conf access lists:

    postgresql::pg_hba { 'Open up postgresql for access from 200.1.2.0/24':
      type => 'host',
      database => 'app',
      user => 'app',
      address => '200.1.2.0/24',
      auth_method => 'md5',
    }

Finally, we've also added Travis-CI support and unit tests to help us iterate faster with tests to reduce regression. The current URL for these tests is here: https://travis-ci.org/puppetlabs/puppet-postgresql. Instructions on how to run the unit tests available are provided in the README for the module.

A big thanks to all those listed below who made this feature release possible :-).

#### Detailed Changes

2013-01-18 - Sim??o Fontes <simaofontes@gmail.com> & Flaper Fesp <flaper87@gmail.com>
* Remove trailing commas from params.pp property definition for Puppet 2.6.0 compatibility

2013-01-18 - Lauren Rother <lauren.rother@puppetlabs.com>
* Updated README.md to conform with best practices template

2013-01-09 - Adrien Thebo <git@somethingsinistral.net>
* Update postgresql_default_version to 9.1 for Debian 7.0

2013-01-28 - Karel Brezina <karel.brezina@gmail.com>
* Add support for tablespaces

2013-01-16 - Chris Price <chris@puppetlabs.com> & Karel Brezina <karel.brezina@gmail.com>
* Provide support for an 'include' config file 'postgresql_conf_extras.conf' that users can modify manually or outside of the module.

2013-01-31 - jv <jeff@jeffvier.com>
* Fix typo in README.pp for postgresql::db example

2013-02-03 - Ken Barber <ken@bob.sh>
* Add unit tests and travis-ci support

2013-02-02 - Ken Barber <ken@bob.sh>
* Add locale parameter support to the 'postgresql' class

2013-01-21 - Michael Arnold <github@razorsedge.org>
* Add a class for install the packages containing the PostgreSQL JDBC jar

2013-02-06 - fhrbek <filip.hbrek@gmail.com>
* Coding style fixes to reduce warnings in puppet-lint and Geppetto

2013-02-10 - Ken Barber <ken@bob.sh>
* Provide new defined resource for managing pg_hba.conf

2013-02-11 - Ken Barber <ken@bob.sh>
* Fix bug with reload of Postgresql on Redhat/Centos

2013-02-15 - Erik Dal??n <dalen@spotify.com>
* Fix more style issues to reduce warnings in puppet-lint and Geppetto

2013-02-15 - Erik Dal??n <dalen@spotify.com>
* Fix case whereby we were modifying a hash after creation


##2.0.1

Minor bugfix release.

2013-01-16 - Chris Price <chris@puppetlabs.com>
 * Fix revoke command in database.pp to support postgres 8.1 (43ded42)

2013-01-15 - Jordi Boggiano <j.boggiano@seld.be>
 * Add support for ubuntu 12.10 status (3504405)

##2.0.0

Many thanks to the following people who contributed patches to this
release:

* Adrien Thebo
* Albert Koch
* Andreas Ntaflos
* Brett Porter
* Chris Price
* dharwood
* Etienne Pelletier
* Florin Broasca
* Henrik
* Hunter Haugen
* Jari Bakken
* Jordi Boggiano
* Ken Barber
* nzakaria
* Richard Arends
* Spenser Gilliland
* stormcrow
* William Van Hevelingen

Notable features:

   * Add support for versions of postgres other than the system default version
     (which varies depending on OS distro).  This includes optional support for
     automatically managing the package repo for the "official" postgres yum/apt
     repos.  (Major thanks to Etienne Pelletier <epelletier@maestrodev.com> and
     Ken Barber <ken@bob.sh> for their tireless efforts and patience on this
     feature set!)  For example usage see `tests/official-postgresql-repos.pp`.

   * Add some support for Debian Wheezy and Ubuntu Quantal

   * Add new `postgres_psql` type with a Ruby provider, to replace the old
     exec-based `psql` type.  This gives us much more flexibility around
     executing SQL statements and controlling their logging / reports output.

   * Major refactor of the "spec" tests--which are actually more like
     acceptance tests.  We now support testing against multiple OS distros
     via vagrant, and the framework is in place to allow us to very easily add
     more distros.  Currently testing against Cent6 and Ubuntu 10.04.

   * Fixed a bug that was preventing multiple databases from being owned by the
     same user
     (9adcd182f820101f5e4891b9f2ff6278dfad495c - Etienne Pelletier <epelletier@maestrodev.com>)

   * Add support for ACLs for finer-grained control of user/interface access
     (b8389d19ad78b4fb66024897097b4ed7db241930 - dharwood <harwoodd@cat.pdx.edu>)

   * Many other bug fixes and improvements!

---
##1.0.0

2012-09-17 - Version 0.3.0 released

2012-09-14 - Chris Price <chris@puppetlabs.com>
 * Add a type for validating a postgres connection (ce4a049)

2012-08-25 - Jari Bakken <jari.bakken@gmail.com>
 * Remove trailing commas. (e6af5e5)

2012-08-16 - Version 0.2.0 released
