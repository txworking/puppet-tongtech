class tongweb::enterprise{
	include install,run
}
class tongweb::enterprise::install {
	Exec <|title == "tongweb_stop"|> { 
		before => Exec["tongweb_enterprise_install"],
		require => Class["tongweb::enterprise::install"],
		}
	file { "/usr/local/src/installer_Enterprise.properties":
	     source => "puppet://$puppetserver/tongweb/installer_Enterprise.properties",
		 before => Exec["tongweb_enterprise_install"];
	    }
	file { "/usr/local/src/Silent_Installer_Enterprise_TongWeb.bin":
	     mode => 0755,
	     source => "puppet://$puppetserver/tongweb/Enterprise/Silent_Installer_Enterprise_TongWeb.bin",
		 before => Exec["tongweb_enterprise_install"],
	    }
	exec { "tongweb_enterprise_install":
		 command => "/bin/sh Silent_Installer_Enterprise_TongWeb.bin -i silent -f installer_Enterprise.properties",
		 path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
		 cwd => "/usr/local/src",
		 require => Class["tongweb::standard::install"],
	    }
}
class tongweb::enterprise::run {
	#Exec <|title == "tongweb_start"|>{ require => Class["tongweb::enterprise::install"]}
}