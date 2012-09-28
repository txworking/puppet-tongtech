
define tongweb::cluster::worker($clustername,$jvmroute,$ajpport){
	@@apache::cluster::workerproperty{ "worker_${hostname}":
		list => "${clustername}",
		ipaddr => "${ipaddress}",
		port => "${ajpport}",
		worker => "${jvmroute}"
		tag => "${clustername}",
	}
}