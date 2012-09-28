class tongweb::virtual{
	
	@exec { "tongweb_start":
		command => "/bin/sh stopserver.sh && nohup /bin/sh startservernohup.sh > runtime.log &",
		path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
		cwd => "/usr/local/tongweb/bin",
		environment => "JAVA_HOME=/usr/lib/jvm/java-6-openjdk-amd64",
		logoutput => true,
		tries => 3,
		try_sleep => 3,
		timeout => 0,
	}
	@exec { "tongweb_stop":
		command => "/bin/sh stopserver.sh",
		path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
		cwd => "/usr/local/tongweb/bin",
		environment => "JAVA_HOME=/usr/lib/jvm/java-6-openjdk-amd64",
		logoutput => true,
		tries => 3,
		try_sleep => 3,
		timeout => 0,
		
	}
}