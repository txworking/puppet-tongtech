define apache::cluster::workerproperty($list,$ipaddr,$port = 2000,$worker = $hostname){
	file_line{ "worker.${worker}.type":
		line => "worker.${worker}.type=ajp13",
		path => "/usr/local/apache/conf/workers.properties"
	}
	file_line{ "worker.${worker}.host":
		line => "worker.${worker}.host=${ipaddr}",
		path => "/usr/local/apache/conf/workers.properties"
	}
	file_line{ "worker.${worker}.port":
		line => "worker.${worker}.port=${port}",
		path => "/usr/local/apache/conf/workers.properties"
	}
	file_line{ "worker.${worker}.lbfactor":
		line => "worker.${worker}.lbfactor=1",
		path => "/usr/local/apache/conf/workers.properties"
	}
	file_line{ "worker.${worker}.socket_keepalive":
		line => "worker.${worker}.socket_keepalive=1",
		path => "/usr/local/apache/conf/workers.properties"
	}
	file_line{ "worker.${worker}.socket_timeout":
		line => "worker.${worker}.socket_timeout=300",
		path => "/usr/local/apache/conf/workers.properties"
	}
	file_line{ "worker.${worker}.redirect":
		line => "worker.${worker}.redirect=ms3",
		path => "/usr/local/apache/conf/workers.properties"
	}
	exec{"add_${worker}":
		command => "sed -i '/^worker\.loadbalancer\.balance_workers.*$/s//&,${worker}/g' workers.properties",
		path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
		cwd => "/usr/local/apache/conf/",
		logoutput => true,
		timeout => 0,
	}
}