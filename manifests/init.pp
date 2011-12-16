# Resource: java6
#
# This modules ensures that Java 6 is installed, and installs it if needed.
# This modules is made for ubuntu and requires the APT module
#
# Parameters:
#  [*present*] : default to true, if set to false, uninstall Java 6
#
# Actions:
# Checks whether Java 6 (Hotspot) is installed and installs if needed.
# The JDK is installed using apt
#
# Requires:
# the apt puppet module
# Sample Usage:
# java6 { "Java6SDK" :}
# 
define java6 ($present = true) {
	
	# First we need to have the partner repository:
	apt::source { "partner":
	    location => "http://archive.canonical.com/ubuntu",
	    release => "${lsbdistcodename}",
	    repos => "partner",
	    include_src => false,
	}
	
	# To automate License agreement
	file { "/var/cache/debconf/sun-java6.preseed":
	    source => "puppet:///modules/java6/sun-java6.preseed",
	    ensure => present
	}
	
	if $present == false {
		package { "sun-java6-jdk":
		    ensure  => purged,
		    require => [ Apt::Source["partner"], File["/var/cache/debconf/sun-java6.preseed"] ],
		}
	} else {
		package { "sun-java6-jdk":
		    ensure  => installed,
		    responsefile => "/var/cache/debconf/sun-java6.preseed",
		    require => [ Apt::Source["partner"], File["/var/cache/debconf/sun-java6.preseed"] ],
		}
	}
}
