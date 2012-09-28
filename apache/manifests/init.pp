include ::stdlib

class apache{
	include apache::virtual,apache::install,apache::run
}
class apache::install{
	file { "/usr/local/src/httpd-2.2.22.tar.gz":
	     source => "puppet://$puppetserver/apache/httpd-2.2.22.tar.gz",
		}
	exec{"install_apache":
		command => "tar -zxvf httpd-2.2.22.tar.gz && cd httpd-2.2.22 && ./configure --prefix=/usr/local/apache --enable-modules=most --enable-mods-shared=all --enable-so && make && make install",
		path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
		cwd => "/usr/local/src",
		logoutput => on_failure,
		timeout => 0,
	}
	File["/usr/local/src/httpd-2.2.22.tar.gz"] -> Exec["install_apache"]
}

class apache::run {
	#Exec <| title == "stop_apache"|>
	#Exec <| title == "start_apache"|>
	#Class["apache::install"] -> Exec["stop_apache"] -> Exec["start_apache"]
}