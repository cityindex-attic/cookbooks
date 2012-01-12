maintainer       "CityIndex Ltd."
maintainer_email "me@ryangeyer.com"
license          IO.read(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'LICENSE.txt')))
description      "Installs/Configures shapado"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.3"

supports "ubuntu"

%w{rvm nginx unicorn rs_utils}.each do |d|
  depends d
end

recipe "shapado::default","Installs and configures the Shapado FAQ rails application using ruby_enterprise and unicorn"
recipe "shapado::install_shapado","Does the same thing as default, but for later more mature versions of shapado"

attribute "shapado/fqdn",
  :display_name => "Shapado VHOST FQDN",
  :description => "The fully qualified domain name (FQDN) of the new vhost to deploy shapado to.  Example www.apache.org",
  :required => true,
  :recipes => ["shapado::default","shapado::install_shapado"]

attribute "shapado/aliases",
  :display_name => "Shapado VHOST Aliases",
  :description => "The possible hostname aliases (if any) for the vhost.  For instance to host the same content at www.yourdomain.com and yourdomain.com simply put \"yourdomain.com\" here.  Many values can be supplied, separated by spaces",
  :default => "",
  :recipes => ["shapado::default","shapado::install_shapado"]

attribute "shapado/recaptcha_enable",
  :display_name => "Shapado Enable Recaptcha",
  :description => "A boolean indicating of recaptcha support should be used.  If true, shapado/recaptcha_public_key and shapado/recaptcha_private_key must be set",
  :default => "false",
  :recipes => ["shapado::default","shapado::install_shapado"]

attribute "shapado/recaptcha_public_key",
  :display_name => "Shapado Recaptcha Public Key",
  :recipes => ["shapado::default","shapado::install_shapado"]

attribute "shapado/recaptcha_private_key",
  :display_name => "Shapado Recaptcha Private Key",
  :recipes => ["shapado::default","shapado::install_shapado"]

attribute "shapado/version",
  :display_name => "Shapado Version",
  :description => "The version/branch/tag/commit of the gitorious repo to use",
  :required => "optional",
  :default => "master",
  :recipes => ["shapado::default","shapado::install_shapado"]

attribute "rails/version",
  :display_name => "Rails Version",
  :description => "The full version number of rails to install.  I.E. 3.0.5  If no value is provided, the latest available version is installed.",
  :required => "optional",
  :recipes => ["shapado::default","shapado::install_shapado"]

attribute "rails/environment",
  :display_name => "Rails Environment",
  :description => "The desired rails environment to run.  I.E. production",
  :required => "required",
  :recipes => ["shapado::default","shapado::install_shapado"]

attribute "nginx/dir",
  :display_name => "Nginx Directory",
  :description => "Location of nginx configuration files",
  :default => "/etc/nginx",
  :recipes => ["shapado::default","shapado::install_shapado"]

attribute "nginx/content_dir",
  :display_name => "Nginx Content Directory",
  :description => "Location of nginx content files",
  :default => "/var/www",
  :recipes => ["shapado::default","shapado::install_shapado"]

attribute "nginx/log_dir",
  :display_name => "Nginx Log Directory",
  :description => "Location for nginx logs",
  :default => "/var/log/nginx",
  :recipes => ["shapado::default","shapado::install_shapado"]

attribute "nginx/user",
  :display_name => "Nginx User",
  :description => "User nginx will run as",
  :default => "www-data",
  :recipes => ["shapado::default","shapado::install_shapado"]

attribute "nginx/binary",
  :display_name => "Nginx Binary",
  :description => "Location of the nginx server binary",
  :default => "/usr/sbin/nginx",
  :recipes => ["shapado::default","shapado::install_shapado"]

attribute "nginx/gzip",
  :display_name => "Nginx Gzip",
  :description => "Whether gzip is enabled",
  :default => "on",
  :recipes => ["shapado::default","shapado::install_shapado"]

attribute "nginx/gzip_http_version",
  :display_name => "Nginx Gzip HTTP Version",
  :description => "Version of HTTP Gzip",
  :default => "1.0",
  :recipes => ["shapado::default","shapado::install_shapado"]

attribute "nginx/gzip_comp_level",
  :display_name => "Nginx Gzip Compression Level",
  :description => "Amount of compression to use",
  :default => "2",
  :recipes => ["shapado::default","shapado::install_shapado"]

attribute "nginx/gzip_proxied",
  :display_name => "Nginx Gzip Proxied",
  :description => "Whether gzip is proxied",
  :default => "any",
  :recipes => ["shapado::default","shapado::install_shapado"]

attribute "nginx/gzip_types",
  :display_name => "Nginx Gzip Types",
  :description => "Supported MIME-types for gzip",
  :type => "array",
  :default => [ "text/plain", "text/html", "text/css", "application/x-javascript", "text/xml", "application/xml", "application/xml+rss", "text/javascript" ],
  :recipes => ["shapado::default","shapado::install_shapado"]

attribute "nginx/keepalive",
  :display_name => "Nginx Keepalive",
  :description => "Whether to enable keepalive",
  :default => "on",
  :recipes => ["shapado::default","shapado::install_shapado"]

attribute "nginx/keepalive_timeout",
  :display_name => "Nginx Keepalive Timeout",
  :default => "65",
  :recipes => ["shapado::default","shapado::install_shapado"]

attribute "nginx/worker_processes",
  :display_name => "Nginx Worker Processes",
  :description => "Number of worker processes",
  :default => "1",
  :recipes => ["shapado::default","shapado::install_shapado"]

attribute "nginx/worker_connections",
  :display_name => "Nginx Worker Connections",
  :description => "Number of connections per worker",
  :default => "1024",
  :recipes => ["shapado::default","shapado::install_shapado"]

attribute "nginx/server_names_hash_bucket_size",
  :display_name => "Nginx Server Names Hash Bucket Size",
  :default => "64",
  :recipes => ["shapado::default","shapado::install_shapado"]

attribute "nginx/aliases",
  :display_name => "Nginx Site Aliases",
  :description => "The possible hostname aliases (if any) for the vhost.  For instance to host the same content at www.yourdomain.com and yourdomain.com simply put \"yourdomain.com\" here.  Many values can be supplied, separated by spaces. The full syntax which Nginx supports for the server_name directive are applicable here, http://wiki.nginx.org/HttpCoreModule#server_name",
  :type => "array",
  :default => [],
  :required => "recommended",
  :recipes => ["shapado::default","shapado::install_shapado"]

# HAX
attribute "rvm/install_path",
  :display_name => "RVM Installation Path",
  :description => "The full path where RVM will be installed. I.E. /opt/rvm",
  :required => "optional",
  :default => "/opt/rvm",
  :recipes => ["shapado::default","shapado::install_shapado"]