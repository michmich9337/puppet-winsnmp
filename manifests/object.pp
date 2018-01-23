# == Define: winsnmp::object
#
# Configure an RFC1156 object on Windows SNMP installations.
#
# See `README.md` for more details.
#
# === Authors
#
# * Florian MICHAUX <michmich@cyberspace.wtf>
#
# === Copyright
#
# Copyright 2017 Cyberspace
#
define winsnmp::object (
  $value,
  $object = $title,
  $type   = 'string',
) {
  $path = 'HKLM\SYSTEM\CurrentControlSet\services\SNMP\Parameters\RFC1156Agent'

  registry_value { "${path}\\${object}":
    ensure => present,
    type   => $type,
    data   => $value,
    notify => Service[$winsnmp::service],
  }
}
