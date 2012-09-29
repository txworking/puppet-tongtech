include stdlib
class tongweb {
	include virtual,params,standard
}

class tongweb::params {
	exec { "add_nameserver":
		 command => "/bin/echo 'nameserver 8.8.8.8' >> /etc/resolv.conf", 
		 unless => "/bin/grep -Fx 'nameserver 8.8.8.8' etc/resolv.conf ",
		 path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
	     cwd => "/etc",
	     }
	
	exec { "apt-update":
        command => "/usr/bin/apt-get update",
		path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
        require => Exec["add_nameserver"],
      }
	
	package { "openjdk-6-jdk":
		ensure => "installed",
		#require => Exec["apt-update"],
	}
}

class tongweb::monitor::jmx {
	file { "/usr/local/nagios/libexec/check_jmx":
		 source => "puppet://$puppetserver/tongweb/jmxquery/check_jmx",
		 ensure => present,
	     owner => 'nagios',
	     group => 'nagios',
	     mode => 0755,
	}
	file { "/usr/local/nagios/libexec/jmxquery.jar":
		 source => "puppet://$puppetserver/tongweb/jmxquery/jmxquery.jar",
		 ensure => present,
	     owner => 'nagios',
	     group => 'nagios',
	}
	@@nagios_service { "check_tongweb_jmx_${hostname}":
		check_command => "check_nrpe!check_jmx",
		use => "generic-service",
		host_name => "$hostname",
		check_period => "24x7",
		max_check_attempts => "4",
		normal_check_interval => "3",
		retry_check_interval  => "2",
		service_description   => "${hostname}_check_jmx",
		target => "/usr/loacl/nagios/etc/objects/services.cfg", 
		}
	exec { "add-check_jmx-command":
		 command => "echo 'command[check_jmx]=/usr/local/nagios/libexec/check_jmx -U service:jmx:rmi:///jndi/rmi://localhost:7200/jmxrmi -O java.lang:type=Memory -A HeapMemoryUsage -K used -I HeapMemoryUsage -J used -vvvv -w 731847066 -c 1045495808 -username admin -password adminadmin' >> /usr/local/nagios/etc/nrpe.cfg",
		 unless => "/bin/grep -Fx 'command[check_jmx]=/usr/local/nagios/libexec/check_jmx -U service:jmx:rmi:///jndi/rmi://localhost:7200/jmxrmi -O java.lang:type=Memory -A HeapMemoryUsage -K used -I HeapMemoryUsage -J used -vvvv -w 731847066 -c 1045495808 -username admin -password adminadmin' /usr/local/nagios/etc/nrpe.cfg",
		 path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
		 cwd => "/usr/local/nagios/etc",
		 require => Class["tongweb::params"],
		 subscribe => Package["openjdk-6-jdk"],
	    }
}
