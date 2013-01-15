maintainer       "CityIndex Ltd."
maintainer_email "me@ryangeyer.com"
license          "Apache 2.0"
description      "Installs/Configures shapado"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.3"

supports "ubuntu"

%w{rvm nginx unicorn rightscale}.each do |d|
  depends d
end

recipe "shapado::default","Installs and configures the Shapado FAQ rails application using ruby_enterprise and unicorn"
recipe "shapado::install_shapado_rvm_gemset","Installs and configures shapado.  The required gems are installed from an RVM gemset file.  This is for 'older' versions of Shapado, effectively anything using Rails 2.3.x"
recipe "shapado::install_shapado_bundler","Does the same thing as install_shapado_rvm_gemset.  The required gems are installed with bundler.  This is for 'newer' versions of Shapado, effectively anything using Rails 3.x"

attribute "shapado/fqdn",
  :display_name => "Shapado VHOST FQDN",
  :description => "The fully qualified domain name (FQDN) of the new vhost to deploy shapado to.  Example www.apache.org",
  :required => true,
  :recipes => ["shapado::install_shapado_rvm_gemset","shapado::install_shapado_bundler"]

attribute "shapado/aliases",
  :display_name => "Shapado VHOST Aliases",
  :description => "The possible hostname aliases (if any) for the vhost.  For instance to host the same content at www.yourdomain.com and yourdomain.com simply put \"yourdomain.com\" here.  Many values can be supplied, separated by spaces",
  :default => "",
  :recipes => ["shapado::install_shapado_rvm_gemset","shapado::install_shapado_bundler"]

attribute "shapado/recaptcha_enable",
  :display_name => "Shapado Enable Recaptcha",
  :description => "A boolean indicating of recaptcha support should be used.  If true, shapado/recaptcha_public_key and shapado/recaptcha_private_key must be set",
  :default => "false",
  :recipes => ["shapado::install_shapado_rvm_gemset","shapado::install_shapado_bundler"]

attribute "shapado/recaptcha_public_key",
  :display_name => "Shapado Recaptcha Public Key",
  :recipes => ["shapado::install_shapado_rvm_gemset","shapado::install_shapado_bundler"]

attribute "shapado/recaptcha_private_key",
  :display_name => "Shapado Recaptcha Private Key",
  :recipes => ["shapado::install_shapado_rvm_gemset","shapado::install_shapado_bundler"]

attribute "shapado/repository",
  :display_name => "Shapado Git Repository",
  :description => "The shapado git repository from which to fetch the shapado application code",
  :required => "optional",
  :default => "git://github.com/cityindex/shapado.git",
  :recipes => ["shapado::install_shapado_bundler"]

attribute "shapado/version",
  :display_name => "Shapado Version",
  :description => "The version/branch/tag/commit of the gitorious repo to use",
  :required => "optional",
  :default => "master",
  :recipes => ["shapado::install_shapado_rvm_gemset","shapado::install_shapado_bundler"]

attribute "rails/version",
  :display_name => "Rails Version",
  :description => "The full version number of rails to install.  I.E. 3.0.5  If no value is provided, the latest available version is installed.",
  :required => "optional",
  :recipes => ["shapado::default"]

attribute "rails/environment",
  :display_name => "Rails Environment",
  :description => "The desired rails environment to run.  I.E. production",
  :required => "required",
  :recipes => ["shapado::install_shapado_rvm_gemset","shapado::install_shapado_bundler"]

attribute "nginx/dir",
  :display_name => "Nginx Directory",
  :description => "Location of nginx configuration files",
  :default => "/etc/nginx",
  :recipes => ["shapado::install_shapado_rvm_gemset","shapado::install_shapado_bundler"]

attribute "nginx/content_dir",
  :display_name => "Nginx Content Directory",
  :description => "Location of nginx content files",
  :default => "/var/www",
  :recipes => ["shapado::install_shapado_rvm_gemset","shapado::install_shapado_bundler"]

attribute "nginx/log_dir",
  :display_name => "Nginx Log Directory",
  :description => "Location for nginx logs",
  :default => "/var/log/nginx",
  :recipes => ["shapado::install_shapado_rvm_gemset","shapado::install_shapado_bundler"]

attribute "nginx/user",
  :display_name => "Nginx User",
  :description => "User nginx will run as",
  :default => "www-data",
  :recipes => ["shapado::install_shapado_rvm_gemset","shapado::install_shapado_bundler"]

attribute "nginx/binary",
  :display_name => "Nginx Binary",
  :description => "Location of the nginx server binary",
  :default => "/usr/sbin/nginx",
  :recipes => ["shapado::install_shapado_rvm_gemset","shapado::install_shapado_bundler"]

attribute "nginx/gzip",
  :display_name => "Nginx Gzip",
  :description => "Whether gzip is enabled",
  :default => "on",
  :recipes => ["shapado::install_shapado_rvm_gemset","shapado::install_shapado_bundler"]

attribute "nginx/gzip_http_version",
  :display_name => "Nginx Gzip HTTP Version",
  :description => "Version of HTTP Gzip",
  :default => "1.0",
  :recipes => ["shapado::install_shapado_rvm_gemset","shapado::install_shapado_bundler"]

attribute "nginx/gzip_comp_level",
  :display_name => "Nginx Gzip Compression Level",
  :description => "Amount of compression to use",
  :default => "2",
  :recipes => ["shapado::install_shapado_rvm_gemset","shapado::install_shapado_bundler"]

attribute "nginx/gzip_proxied",
  :display_name => "Nginx Gzip Proxied",
  :description => "Whether gzip is proxied",
  :default => "any",
  :recipes => ["shapado::install_shapado_rvm_gemset","shapado::install_shapado_bundler"]

attribute "nginx/gzip_types",
  :display_name => "Nginx Gzip Types",
  :description => "Supported MIME-types for gzip",
  :type => "array",
  :default => [ "text/plain", "text/html", "text/css", "application/x-javascript", "text/xml", "application/xml", "application/xml+rss", "text/javascript" ],
  :recipes => ["shapado::install_shapado_rvm_gemset","shapado::install_shapado_bundler"]

attribute "nginx/keepalive",
  :display_name => "Nginx Keepalive",
  :description => "Whether to enable keepalive",
  :default => "on",
  :recipes => ["shapado::install_shapado_rvm_gemset","shapado::install_shapado_bundler"]

attribute "nginx/keepalive_timeout",
  :display_name => "Nginx Keepalive Timeout",
  :default => "65",
  :recipes => ["shapado::install_shapado_rvm_gemset","shapado::install_shapado_bundler"]

attribute "nginx/worker_processes",
  :display_name => "Nginx Worker Processes",
  :description => "Number of worker processes",
  :default => "1",
  :recipes => ["shapado::install_shapado_rvm_gemset","shapado::install_shapado_bundler"]

attribute "nginx/worker_connections",
  :display_name => "Nginx Worker Connections",
  :description => "Number of connections per worker",
  :default => "1024",
  :recipes => ["shapado::install_shapado_rvm_gemset","shapado::install_shapado_bundler"]

attribute "nginx/server_names_hash_bucket_size",
  :display_name => "Nginx Server Names Hash Bucket Size",
  :default => "64",
  :recipes => ["shapado::install_shapado_rvm_gemset","shapado::install_shapado_bundler"]

attribute "nginx/aliases",
  :display_name => "Nginx Site Aliases",
  :description => "The possible hostname aliases (if any) for the vhost.  For instance to host the same content at www.yourdomain.com and yourdomain.com simply put \"yourdomain.com\" here.  Many values can be supplied, separated by spaces. The full syntax which Nginx supports for the server_name directive are applicable here, http://wiki.nginx.org/HttpCoreModule#server_name",
  :type => "array",
  :default => [],
  :required => "recommended",
  :recipes => ["shapado::install_shapado_rvm_gemset","shapado::install_shapado_bundler"]

attribute "rightscale/timezone",
  :display_name => "Timezone",
  :description => "Sets the system time to the timezone of the specified input, which must be a valid zoneinfo/tz database entry.  If the input is 'unset' the timezone will use the 'localtime' that's defined in your RightScale account under Settings -> User Settings -> Preferences tab.  You can find a list of valid examples from the timezone pulldown bar in the Preferences tab.  Ex: US/Pacific, US/Eastern",
  :required => "optional",
  :choice => [
    "Africa/Casablanca",
    "America/Bogota",
    "America/Buenos_Aires",
    "America/Caracas",
    "America/La_Paz",
    "America/Lima",
    "America/Mexico_City",
    "Asia/Almaty",
    "Asia/Baghdad",
    "Asia/Baku",
    "Asia/Bangkok",
    "Asia/Calcutta",
    "Asia/Colombo",
    "Asia/Dhaka",
    "Asia/Hong_Kong",
    "Asia/Jakarta",
    "Asia/Kabul",
    "Asia/Kamchatka",
    "Asia/Karachi",
    "Asia/Kathmandu",
    "Asia/Magadan",
    "Asia/Muscat",
    "Asia/Riyadh",
    "Asia/Seoul",
    "Asia/Singapore",
    "Asia/Tashkent",
    "Asia/Tbilisi",
    "Asia/Tehran",
    "Asia/Tokyo",
    "Asia/Vladivostok",
    "Asia/Yakutsk",
    "Asia/Yekaterinburg",
    "Atlantic/Azores",
    "Atlantic/Cape_Verde",
    "Australia/Adelaide",
    "Australia/Darwin",
    "Australia/Perth",
    "Brazil/Acre",
    "Brazil/DeNoronha",
    "Brazil/East",
    "Brazil/West",
    "Canada/Atlantic",
    "Canada/Newfoundland",
    "Europe/Brussels",
    "Europe/Copenhagen",
    "Europe/Kaliningrad",
    "Europe/Lisbon",
    "Europe/London",
    "Europe/Helsinki",
    "Europe/Madrid",
    "Europe/Moscow",
    "Europe/Paris",
    "Pacific/Auckland",
    "Pacific/Fiji",
    "Pacific/Guam",
    "Pacific/Kwajalein",
    "Pacific/Midway",
    "US/Alaska",
    "US/Central",
    "US/Eastern",
    "US/Hawaii",
    "US/Mountain",
    "US/Pacific",
    "US/Samoa",
    "GMT",
    "UTC",
    "localtime"
  ],
  :default => "UTC",
  :recipes => ["shapado::default","shapado::install_shapado"]