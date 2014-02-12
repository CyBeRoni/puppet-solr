# == Class: solr::service
# This class sets up solr service
#
# === Actions
# - Sets up jetty service
#
class solr::service {

  file { "/etc/init.d/solr":
    ensure    => 'file',
    owner     => 'root',
    group     => 'root',
    mode      => 0755,
    content   => template('solr/initd-solr.erb'),
  } ->

  #restart after copying new config
  service { 'solr':
    ensure      => running,
    hasrestart  => true,
    hasstatus   => false,
    enable      => true,
  }

}


