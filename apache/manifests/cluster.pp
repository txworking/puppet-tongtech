include ::stdlib

class apache::cluster( $clname ){
	Apache::Cluster::Workerproperty <<| list == "$clname"|>> {
		require => Class["apache::mod_jk::install"],
		before => Exec["stop_apache"],
	}
	file_line{ "worker.list":
		line => "worker.list=${clname}",
		path => "/usr/local/apache/conf/workers.properties",
		before => Exec["stop_apache"],
		require => Class["apache::mod_jk::install"],
	}
	file_line{ "worker.${clname}.type":
		line => "worker.${clname}.type=lb",
		path => "/usr/local/apache/conf/workers.properties",
		before => Exec["stop_apache"],
		require => Class["apache::mod_jk::install"],
	}
	file_line{ "worker.${clname}.balance_workers":
		line => "worker.${clname}.balance_workers=",
		path => "/usr/local/apache/conf/workers.properties",
		before => Exec["stop_apache"],
		require => Class["apache::mod_jk::install"],
	}
	file_line{ "worker.${clname}.sticky_session":
		line => "worker.${clname}.sticky_session=false",
		path => "/usr/local/apache/conf/workers.properties",
		before => Exec["stop_apache"],
		require => Class["apache::mod_jk::install"],
	}
	file_line{ "worker.${clname}.sticky_session_force":
		line => "worker.${clname}.sticky_session_force=true",
		path => "/usr/local/apache/conf/workers.properties",
		before => Exec["stop_apache"],
		require => Class["apache::mod_jk::install"],
	}
	Exec <| title == "stop_apache"|>{
		require => Class["apache::mod_jk::install"],
		#before => Exec["start_apache"]
		}
	
}