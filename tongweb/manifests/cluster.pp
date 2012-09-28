
class tongweb::cluster($clustername,$jvmroute = $hostname,$ajpport){
	include install,run
	::tongweb::cluster::worker{"worker_${hostname}":
		clustername => "${clustername}",
		ajpport => "${ajpport}",
		jvmroute => "${jvmroute}"
	}
}
class tongweb::cluster::install{
	Exec <|title == "tongweb_stop"|> { 
		before => Exec["tongweb_cluster_install"],
		require => Class["tongweb::enterprise::install"],}
	file { "/usr/local/src/installer_Cluster.properties":
	     source => "puppet://$puppetserver/tongweb/installer_Cluster.properties",
		 before => Exec["tongweb_cluster_install"];
	    }
	file { "/usr/local/src/Silent_Installer_Cluster_TongWeb.bin":
	     mode => 0755,
	     source => "puppet://$puppetserver/tongweb/Cluster/Silent_Installer_Cluster_TongWeb.bin",
		 before => Exec["tongweb_cluster_install"],
	    }
	exec { "tongweb_cluster_install":
		 command => "/bin/sh Silent_Installer_Cluster_TongWeb.bin -i silent -f installer_Cluster.properties",
		 path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
		 cwd => "/usr/local/src",
		 require => Class["tongweb::enterprise::install"],
	    }

}
class tongweb::cluster::run {
	Exec <|title == "tongweb_start"|>{ require => Class["tongweb::cluster::install"]}
}
