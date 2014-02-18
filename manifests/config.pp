# == Class: solr::config
# This class sets up solr install
#
# === Parameters
# - The $cores to create
#
# === Actions
# - Copies a new jetty default file
# - Creates solr home directory
# - Downloads solr 4.4.0, extracts war and copies logging jars
# - Creates solr data directory
# - Creates solr config file with cores specified
# - Links solr home directory to jetty webapps directory
#
class solr::config(
) {

  $cores = false
  $jetty_home     = $::solr::jetty_home
  $solr_home      = $::solr::solr_home
  $solr_version   = $::solr::solr_version
  $download_site  = $::solr::download_site
  
  $file_name      = "solr-${solr_version}.tgz"
  $tmp_pkg        = "/tmp/solr-${solr_version}"


  user {$solr::owner:
    ensure => present,
    home => $jetty_home,
    shell => '/sbin/false',
  } ->

  # create installation home
  file { $jetty_home:
    ensure    => directory,
    owner     => $solr::owner,
    group     => $solr::group,
  } ->

  # create installation home
  file { $solr_home:
    ensure    => directory,
    owner     => $solr::owner,
    group     => $solr::group,
  } ->

  #Copy the jetty config file
  file { $solr::jetty_logs:
    ensure  => directory,
    owner   => $solr::owner,
    group   => $solr::owner,
    mode    => 0644,
    # require => Package['jetty'],
  } ->

  # download only if solr_home is not present and tgz file is not in /tmp:
  exec { 'solr-download':
    path      => ['/usr/bin', '/usr/sbin', '/bin'],
    command   =>  "wget ${download_site}/${solr_version}/${file_name}",
    cwd       =>  '/tmp',
    creates   =>  "/tmp/${file_name}",
    onlyif    =>  "test ! -d ${solr_home}/etc && test ! -f /tmp/${file_name}",
    timeout   =>  0,
    require   => File[$jetty_home],
  } ->

  exec { 'extract-solr':
    path      =>  ['/usr/bin', '/usr/sbin', '/bin'],
    command   =>  "tar xzvf ${file_name}",
    cwd       =>  '/tmp',
    onlyif    =>  "test -f /tmp/${file_name} && test ! -d ${tmp_pkg}",
  } ->

  # extract example directory containing solr & jetty
  exec { 'copy-solr':
    path      =>  ['/usr/bin', '/usr/sbin', '/bin'],
    command   =>  "cp -R cloud-scripts contexts etc lib resources solr-webapp webapps start.jar ${jetty_home}; chown -R solr:solr ${jetty_home}/*",
    cwd       =>  "$tmp_pkg/example",
    onlyif    =>  "test ! -d ${solr_home}/etc",
  } ->

  #Copy the jetty config file
  file { $solr::params::jetty_default:
    ensure  => file,
    content  => template('solr/jetty-default.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    notify  => Service['solr'],
  } ->

  #Copy the jetty config file
  file { "${jetty_home}/etc/jetty-logging.xml":
    ensure  => file,
    content  => template('solr/jetty-logging.xml.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    # require => Package['jetty'],
  } ->


  file { "${solr_home}/solr.xml":
    ensure    => 'file',
    owner     => $solr::owner,
    group     => $solr::group,
    content   => template('solr/solr.xml.erb'),
    notify    => Service['solr'],
  }

  # file { "${jetty_home}/webapps/solr":
  #   ensure    => 'link',
  #   target    => $solr_home,
  #   require   => File["${solr_home}/solr.xml"],
  # }

  if $cores {
    solr::core { $cores:
    }
  }
}

