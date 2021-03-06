# Class: labsignups
# ===========================
#
# Full description of class labsignups here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'labsignups':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class labsignups {
  include apache
  include epel
  file { '/srv':
    ensure => directory,
  }

  package { 'ruby':
    ensure => latest,
  }

  package { 'git':
    ensure   => latest,
  }

  package { 'bundler':
    ensure   => present,
    provider => 'gem',
    require  => Package['ruby']
  }

  package { 'rack':
    ensure   => '1.6.4',
    provider => 'gem',
    require  => Package['ruby']
  }

  package { 'sinatra':
    ensure   => latest,
    provider => 'gem',
    require  => Package['ruby']
  }

  vcsrepo { '/srv/labsignups':
    ensure   => present,
    provider => git,
    remote   => 'origin',
    owner    => 'apache',
    source   => {
      'origin'       => 'https://github.com/ncorrare/labsignups.git'
    },
    require => File['/srv'],
  }
  
  apache::vhost { 'puppetmaster-idc.cloudapp.net':
    port    => '80',
    docroot => '/srv/labsignups/public',
    require => Vcsrepo['/srv/labsignups'],
  }
  class { 'apache::mod::passenger':
  }

}
