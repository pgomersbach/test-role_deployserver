# == Class role_deployserver::service
#
# This class is meant to be called from role_deployserver.
# It ensure the service is running.
#
class role_deployserver::service {

  service { $::role_deployserver::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
