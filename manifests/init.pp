# == Class: winsnmp
#
# Manages the SNMP service under Windows.
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
class winsnmp (
  $communities = [],
  $managers    = [],
  $contact     = '',
  $location    = '',
  $services    = 76,
) {
  validate_array($communities)
  validate_array($managers)

  $feature = 'SNMP'
  $service = 'snmp'

  dism { $feature:
    ensure => present,
  }

  dism { 'Server-RSAT-SNMP':
    ensure => present,
  }

  service { $service:
    ensure  => running,
    require => Dism[$feature],
  }

  # Ensure required keys are present and that they only contain our values.
  registry_key { [
    'HKLM\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers',
    'HKLM\SYSTEM\CurrentControlSet\services\SNMP\Parameters\RFC1156Agent',
    'HKLM\SYSTEM\CurrentControlSet\services\SNMP\Parameters\ValidCommunities' ]:
    purge_values => true,
    require      => Dism[$feature],
    notify       => Service[$service],
  }

  # Configure all necessary community strings.
  winsnmp::community { [$communities]: }

  # Configure all necessary permitted managers strings.
  winsnmp::managers { [$managers]: }

  # Set the standard RFC1156 objects.
  if $contact {
    winsnmp::object { 'sysContact':
      value => $contact,
    }
  }
  if $location {
    winsnmp::object { 'sysLocation':
      value => $location,
    }
  }
  if $services {
    winsnmp::object { 'sysServices':
      type  => 'dword',
      value => $services,
    }
  }
}
