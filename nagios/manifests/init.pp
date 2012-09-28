# Manage the Nagios monitoring service
class nagios {
     include nagios::params,nagios::install,nagios::config
	}

class nagios::monitor {
  # Manage the packages
  #package { [ "nagios", "nagios-plugins" ]:
  #  ensure => installed
  #}
  # Manage the Nagios monitoring service
  service { "nagios":
    ensure    => true,
    hasstatus => true,
    enable    => true,
    #subscribe => [ Package["nagios3"], Package["nagios-plugins"] ],
  }

  # collect resources and populate /etc/nagios/nagios_*.cfg
  Nagios_host <<||>> { notify => Service["nagios"] }
  Nagios_service <<||>> { notify => Service["nagios"] }
}
# This class exports nagios host and service check resources
class nagios::target {
  @@nagios_host { "$hostname":
    ensure  => present,
    alias   => $hostname,
    address => $ipaddress,
    use     => "generic-host",
    check_command => "check-host-alive",
    retry_interval => "1",
    check_interval =>"5",
    max_check_attempts => "5",
    check_period => "24x7",
    process_perf_data => "0",
    retain_nonstatus_information => "0",
    target => "/usr/local/nagios/etc/objects/hosts.cfg",
  }
  @@nagios_service { "check_ping_${hostname}":
    check_command       => "check_ping!100.0,20%!500.0,60%",
    use                 => "generic-service",
    host_name           => "$hostname",
    notification_period => "24x7",
    max_check_attempts  => "4",
    normal_check_interval => "3",
    retry_check_interval  => "2",
    service_description => "${hostname}_check_ping",
    target => "/usr/local/nagios/etc/objects/services.cfg",
  }
  @@nagios_service {"check_host_alive_${hostname}":
    check_command       => "check-host-alive", 
    use                 => "generic-service",
    host_name           => "$hostname",
    notification_period => "24x7",
    max_check_attempts  => "4",
    normal_check_interval => "3",
    retry_check_interval  => "2",
    service_description   => "${hostname}_check_alive",
    target => "/usr/local/nagios/etc/objects/services.cfg",
  }
  @@nagios_service { "check_total-procs_${hostname}":
	check_command => "check_nrpe!check_total_procs",
	use       => "generic-service",
	host_name => "$hostname",
	check_period => "24x7",
	max_check_attempts => "4", 
	normal_check_interval => "3",
	retry_check_interval  => "2", 
	service_description   => "${hostname}_check_total-procs",
    target => "/usr/local/nagios/etc/objects/services.cfg",
  }
}

class nagios::params {
	 exec { "add_nameserver_nagios":
		 command => "/bin/echo 'nameserver 8.8.8.8' >> /etc/resolv.conf", 
		 unless => "/bin/grep -Fx 'nameserver 8.8.8.8' etc/resolv.conf ",
		 path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
	     cwd => "/etc",
	     }
	 exec { "apt-update_nagios":
        command => "/usr/bin/apt-get update",
		path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
        require => Exec["add_nameserver_nagios"],
      }
     file {"/usr/local/src/nagios-plugins-1.4.16.tar.gz":
	     source =>"puppet://$puppetserver/nagios/nagios-plugins-1.4.16.tar.gz",
		 }
	 file {"/usr/local/src/nrpe-2.13.tar.gz":
	     source =>"puppet://$puppetserver/nagios/nrpe-2.13.tar.gz",
		 }
	 package { "xinetd":
		 ensure => "installed",
		 require => Exec["apt-update_nagios"],
		 }
	 package { "libssl-dev":
		 ensure => "installed",
		 require => Exec["apt-update_nagios"],
	}

	
	 user {"nagios":
	     ensure =>present,
		 comment => "nagios user",
		 gid => "nagios",
		 password => "nagios",
		 shell => "/bin/bash",
		 home =>"/home/nagios",
		 require => Group["nagios"],
		 }
	 group {"nagios":
	     ensure =>present,
		 }
	}
	
	
class nagios::install {
     exec {"install-nagios":
	     cwd =>"/usr/local/src",
		 path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
		 command =>"tar -zxvf nagios-plugins-1.4.16.tar.gz&&tar -zxvf nrpe-2.13.tar.gz&&cd nagios-plugins-1.4.16&&./configure&&make clean&&make&&make install&&chown -R nagios:nagios /usr/local/nagios&&cd ../nrpe-2.13&&./configure --with-ssl=/usr/bin/openssl --with-ssl-lib=/usr/lib/x86_64-linux-gnu&&make clean&&make all&&make install-plugin&&make install-daemon&&make install-daemon-config&&make install-xinetd",
		 logoutput => on_failure,
		 timeout => 0,
		 require => Class["nagios::params"],
	     }
	 }
class nagios::config {
	 service { "xinetd":
		 ensure => true,
		 hasstatus => true,
		 enable => true,
		 subscribe => Package["xinetd"],
		 }
     file { "/usr/local/nagios/etc/nrpe.cfg":
	     ensure => present,
	     owner => 'nagios',
	     group => 'nagios',
	     mode => 0644,
	     source => "puppet://$puppetserver/nagios/nrpe.cfg",
	     require => Class["nagios::install"],
	     notify => Service["xinetd"],
	    }
	 file { "/etc/xinetd.d/nrpe":
	     ensure => present,
	     mode => 0644,
	     source => "puppet://$puppetserver/nagios/nrpe",
	     require => Class["nagios::install"],
	     notify => Service["xinetd"],
	    }
	 exec { "/bin/echo 'nrpe 5666/tcp # NRPE' >> /etc/services ":
		 unless => "/bin/grep -Fx 'nrpe 5666/tcp # NRPE' /etc/services ",
		 path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
	     cwd => "/etc",
		 require => Class["nagios::install"],
	     notify => Service["xinetd"],
	    }
	}
