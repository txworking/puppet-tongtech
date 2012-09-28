class apache::mod_jk{
	include apache::virtual,apache::mod_jk::install
}
class apache::mod_jk::install {
	file { "/usr/local/apache/modules/mod_jk.so":
	     source => "puppet://$puppetserver/apache/mod_jk.so",
		 mode => 0755,
		 alias => "mod_jk.so", 
	    }
	file { "/usr/local/apache/conf/mod_jk.conf":
	     source => "puppet://$puppetserver/apache/mod_jk.conf",
		 alias => "mod_jk.conf"	,
		 }
	file { "/usr/local/apache/conf/workers.properties":
	     source => "puppet://$puppetserver/apache/workers.properties",
		 alias => "workers.properties",
		 
		 
	    }
	file_line{ "include_mod_jk":
		line => "Include conf/mod_jk.conf",
		path => "/usr/local/apache/conf/httpd.conf",
	}
	
	Class["apache::install"] -> File["/usr/local/apache/modules/mod_jk.so"] -> File["/usr/local/apache/conf/mod_jk.conf"] -> File["/usr/local/apache/conf/workers.properties"] -> File_line["include_mod_jk"] 
	
}