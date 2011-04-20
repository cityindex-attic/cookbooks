maintainer       "CityIndex Ltd."
maintainer_email "me@ryangeyer.com"
license          IO.read(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'LICENSE.txt')))
description      "Installs/Configures shapado"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

supports "ubuntu"

recipe "shapado::default","Installs and configures the Shapado FAQ rails application using ruby_enterprise and unicorn"

attribute "shapado/fqdn",
  :display_name => "Shapado VHOST FQDN",
  :description => "The fully qualified domain name (FQDN) of the new vhost to deploy shapado to.  Example www.apache.org",
  :required => true,
  :recipes => ["shapado::default"]

attribute "shapado/aliases",
  :display_name => "Shapado VHOST Aliases",
  :description => "The possible hostname aliases (if any) for the vhost.  For instance to host the same content at www.yourdomain.com and yourdomain.com simply put \"yourdomain.com\" here.  Many values can be supplied, separated by spaces",
  :default => "",
  :recipes => ["shapado::default"]

attribute "rails/version",
  :display_name => "Rails Version",
  :description => "The full version number of rails to install.  I.E. 3.0.5  If no value is provided, the latest available version is installed.",
  :required => "optional",
  :recipes => ["shapado::default"]

attribute "rails/environment",
  :display_name => "Rails Environment",
  :description => "The desired rails environment to run.  I.E. production",
  :required => "required",
  :recipes => ["shapado::default"]

attribute "nginx/dir",
  :display_name => "Nginx Directory",
  :description => "Location of nginx configuration files",
  :default => "/etc/nginx",
  :recipes => ["shapado::default"]

attribute "nginx/content_dir",
  :display_name => "Nginx Content Directory",
  :description => "Location of nginx content files",
  :default => "/var/www",
  :recipes => ["shapado::default"]

attribute "nginx/log_dir",
  :display_name => "Nginx Log Directory",
  :description => "Location for nginx logs",
  :default => "/var/log/nginx",
  :recipes => ["shapado::default"]

attribute "nginx/user",
  :display_name => "Nginx User",
  :description => "User nginx will run as",
  :default => "www-data",
  :recipes => ["shapado::default"]

attribute "nginx/binary",
  :display_name => "Nginx Binary",
  :description => "Location of the nginx server binary",
  :default => "/usr/sbin/nginx",
  :recipes => ["shapado::default"]

attribute "nginx/gzip",
  :display_name => "Nginx Gzip",
  :description => "Whether gzip is enabled",
  :default => "on",
  :recipes => ["shapado::default"]

attribute "nginx/gzip_http_version",
  :display_name => "Nginx Gzip HTTP Version",
  :description => "Version of HTTP Gzip",
  :default => "1.0",
  :recipes => ["shapado::default"]

attribute "nginx/gzip_comp_level",
  :display_name => "Nginx Gzip Compression Level",
  :description => "Amount of compression to use",
  :default => "2",
  :recipes => ["shapado::default"]

attribute "nginx/gzip_proxied",
  :display_name => "Nginx Gzip Proxied",
  :description => "Whether gzip is proxied",
  :default => "any",
  :recipes => ["shapado::default"]

attribute "nginx/gzip_types",
  :display_name => "Nginx Gzip Types",
  :description => "Supported MIME-types for gzip",
  :type => "array",
  :default => [ "text/plain", "text/html", "text/css", "application/x-javascript", "text/xml", "application/xml", "application/xml+rss", "text/javascript" ],
  :recipes => ["shapado::default"]

attribute "nginx/keepalive",
  :display_name => "Nginx Keepalive",
  :description => "Whether to enable keepalive",
  :default => "on",
  :recipes => ["shapado::default"]

attribute "nginx/keepalive_timeout",
  :display_name => "Nginx Keepalive Timeout",
  :default => "65",
  :recipes => ["shapado::default"]

attribute "nginx/worker_processes",
  :display_name => "Nginx Worker Processes",
  :description => "Number of worker processes",
  :default => "1",
  :recipes => ["shapado::default"]

attribute "nginx/worker_connections",
  :display_name => "Nginx Worker Connections",
  :description => "Number of connections per worker",
  :default => "1024",
  :recipes => ["shapado::default"]

attribute "nginx/server_names_hash_bucket_size",
  :display_name => "Nginx Server Names Hash Bucket Size",
  :default => "64",
  :recipes => ["shapado::default"]

attribute "nginx/aliases",
  :display_name => "Nginx Site Aliases",
  :description => "The possible hostname aliases (if any) for the vhost.  For instance to host the same content at www.yourdomain.com and yourdomain.com simply put \"yourdomain.com\" here.  Many values can be supplied, separated by spaces. The full syntax which Nginx supports for the server_name directive are applicable here, http://wiki.nginx.org/HttpCoreModule#server_name",
  :type => "array",
  :default => [],
  :required => "recommended",
   :recipes => ["shapado::default"]

attribute "nginx/accept_fqdn",
  :display_name => "Proxy for FQDN",
  :description => "The FQDN of a domain name which will be proxied to another server and port",
  :required => "required",
  :recipes => ["shapado::default"]

attribute "nginx/dest_fqdn",
  :display_name => "Proxy Destination FQDN",
  :description => "The FQDN the server that will back the proxy, the actual source of the responses for HTTP requests.",
  :required => "required",
  :recipes => ["shapado::default"]

attribute "nginx/dest_port",
  :display_name => "Proxy Port",
  :description => "The the proxy port to forward to",
  :required => "optional",
  :recipes => ["shapado::default"]

attribute "nginx/s3_cert_bucket",
  :display_name => "S3 Bucket",
  :description => "The S3 bucket containing site certificate and key pairs in the pkcs12 format.",
  :required => "required",
  :recipes => ["shapado::default"]

attribute "nginx/pkcs12_pass",
  :display_name => "PKCS12 Cert Password",
  :description => "The password used to protect the PKCS12 file.  This password is specified when the certificate is exported from windows",
  :required => "required",
  :recipes => ["shapado::default"]

attribute "nginx/proxy_http",
  :display_name => "Proxy for HTTP?",
  :description => "A boolean indicating if the proxy should listen and forward traffic on port 80 (HTTP)",
  :required => "required",
  :choice => ["true", "false"],
  :recipes => ["shapado::default"]

attribute "nginx/force_https",
  :display_name => "Force HTTPS?",
  :description => "A boolean indicating if the proxy should redirect all requests to the destination using HTTPS.  This setting requires nginx/proxy_http to be true.",
  :required => "required",
  :choice => ["true", "false"],
  :recipes => ["shapado::default"]