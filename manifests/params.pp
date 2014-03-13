# == Class: solr::params
# This class sets up some required parameters
#
# === Actions
# - Specifies jetty and solr home directories
# - Specifies the default core
#
class solr::params {

  $service = 'solr'
  $jetty_home = '/usr/share/solr'
  $solr_home = "${jetty_home}/solr"
  $jetty_logs = "/var/log/solr"
  $jetty_default = "/etc/default/${service}"
  $solr_version = '4.7.0'
  $owner = 'solr'
  $group = 'solr'
  $host = '0.0.0.0'
  $port = '8080'
  $cores = ['default']

}

