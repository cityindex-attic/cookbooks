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