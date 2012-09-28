class tongweb::standard{
	include install,run
}
class tongweb::standard::install {
	file { "/usr/local/src/installer_Standard.properties":
	     source => "puppet://$puppetserver/tongweb/installer_Standard.properties",
		 before => Exec["tongweb_standard_install"];
	    }
	file { "/usr/local/src/Silent_Installer_Standard_TongWeb.bin":
	     mode => 0755,
	     source => "puppet://$puppetserver/tongweb/Standard/Silent_Installer_Standard_TongWeb.bin",
		 before => Exec["tongweb_standard_install"];
	    }
	file { "/usr/local/tongweb/license.dat":
	     source => "puppet://$puppetserver/tongweb/license.dat",
		 
	    }
	exec { "tongweb_standard_install":
		 command => "/bin/sh Silent_Installer_Standard_TongWeb.bin -i silent -f installer_Standard.properties",
		 path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
		 cwd => "/usr/local/src",
		 require => Class["tongweb::params"],
		 subscribe => Package["openjdk-6-jdk"],
		 before => File["/usr/local/tongweb/license.dat"]
	    }
}
class tongweb::standard::run {
	#Exec <|title == "tongweb_start"|>{require => Class["apache::standard::install"]}
}

