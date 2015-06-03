# == Class role_deployserver::install
#
# This class is called from role_deployserver for install.
#
class role_deployserver::install {

  package { $::role_deployserver::package_name:
    ensure => present,
  }
}
