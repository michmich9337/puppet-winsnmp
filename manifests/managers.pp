# == Define: winsnmp::managers
#
# Configure SNMP Permitted Managers on Windows installations.
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
define winsnmp::managers (
    $index,
    $manager = $title,
    $type    = 'string',
) {
    $path = 'HKLM\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers'
    registry_value { "${path}\\${index}":
      ensure => present,
      type   => $type,
      data   => $manager,
      notify => Service[$winsnmp::service],
    }
}
