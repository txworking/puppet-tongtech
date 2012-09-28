class apache::virtual{
	@exec{"stop_apache":
		command => "/bin/sh apachectl  stop&&netstat -noa|grep 80",
		path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
		cwd => "/usr/local/apache/bin",
		logoutput => true,
		tries => 3,
		try_sleep => 3,
		timeout => 0,
		
	}
	@exec{"start_apache":
		command => "/bin/sh apachectl start",
		path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
		cwd => "/usr/local/apache/bin",
		logoutput => true,
		tries => 3,
		try_sleep => 3,
		timeout => 0,
		
	}
	@exec{"restart_apache":
		command => "/bin/sh apachectl  stop&&netstat -noa|grep 80&&/bin/sh apachectl  restart",
		path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
		cwd => "/usr/local/apache/bin",
		logoutput => true,
		tries => 3,
		try_sleep => 3,
		timeout => 0,
	}
}