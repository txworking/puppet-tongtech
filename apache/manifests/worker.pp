include stdlib
class apache::worker{
	
	file_line{ "worker.list":
		line => "worker.list=loadbalancer",
		path => "/usr/local/apache/conf/workers.properties",
	}
	file_line{ "worker.loadbalancer.type":
		line => "worker.loadbalancer.type=lb",
		path => "/usr/local/apache/conf/workers.properties",
	
	}
	file_line{ "worker.loadbalancer.balance_workers":
		line => "worker.loadbalancer.balance_workers=",
		path => "/usr/local/apache/conf/workers.properties",
		
	}
	file_line{ "worker.loadbalancer.sticky_session":
		line => "worker.loadbalancer.sticky_session=false",
		path => "/usr/local/apache/conf/workers.properties",
	
	}
	file_line{ "worker.loadbalancer.sticky_session_force":
		line => "worker.loadbalancer.sticky_session_force=true",
		path => "/usr/local/apache/conf/workers.properties",
	
	}

}
