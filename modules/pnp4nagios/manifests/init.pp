# Main PNP4Nagios Entry Point
#
class pnp4nagios {

  include [ '::pnp4nagios::params' ]
  include [ '::pnp4nagios::install' ]
  include [ '::pnp4nagios::config' ]
  include [ '::pnp4nagios::service' ]
}
