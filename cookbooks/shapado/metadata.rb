maintainer       "CityIndex Ltd."
maintainer_email "me@ryangeyer.com"
license          IO.read(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'LICENSE.txt')))
description      "Installs/Configures shapado"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

supports "ubuntu"

recipe "shapado::default","Installs and configures the Shapado FAQ rails application using ruby_enterprise and unicorn"