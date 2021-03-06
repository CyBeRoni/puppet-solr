# == Class: solr::params
# This class sets up some required parameters
#
# === Actions
# - Specifies jetty and solr home directories
# - Specifies the default core
#
class solr::params {

  $service = 'solr'
  $jetty_home = '/srv/solr'
  $solr_home = "${jetty_home}/solr"
  $data_home = "${solr_home}/cores"
  $jetty_logs = "/var/log/solr"
  $jetty_default = "/etc/default/${service}"
  $solr_version = '4.7.2'
  $owner = 'solr'
  $group = 'solr'
  $host = '0.0.0.0'
  $port = '8080'
  $cores = ['default']

}

