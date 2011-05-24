#
# Cookbook Name:: shapado
# Recipe:: default
#
#  OpsCode Chef Cookbooks
#  Copyright 2011 CityIndex Ltd.
#
#  This product includes software developed at
#    CityIndex Ltd. (http://www.cityindex.com)

node[:rails][:version] = "2.3.11"

include_recipe "nginx::default"
include_recipe "rails::install"
include_recipe "unicorn::default"

shapado_install_dir = ::File.join(node[:nginx][:content_dir], "shapado")
gemset_file = "shapado-#{node[:shapado][:version]}.gems"
gemset_filepath = ::File.join(shapado_install_dir, gemset_file)

if(node[:shapado][:recaptcha_enable] && (!node[:shapado][:recaptcha_public_key] || node[:shapado][:recaptcha_private_key]))
  raise "Recaptcha support for shapado was enabled, but the public or private API key was empty"
end

# Required for the "magic" gem
package "file"

git shapado_install_dir do
  repository "git://gitorious.org/shapado/shapado.git"
  revision node[:shapado][:version]
  action :sync
  not_if { ::File.directory?(shapado_install_dir) }
end

if Gem::Version.new(Chef::VERSION) >= Gem::Version.new('0.9.0')
  cookbook_file gemset_filepath do
    source gemset_file
  end
else
  remote_file gemset_filepath do
    source gemset_file
  end
end

# TODO: Lots of good configuration bits like enabling social networking and google analytics
template ::File.join(shapado_install_dir, "config", "shapado.yml") do
  source "shapado.yml.erb"
  variables(:uri => node[:shapado][:fqdn])
end

bash "Install gems & bootstrap shapado" do
  cwd ::File.join(node[:nginx][:content_dir], "shapado")
  code <<-EOF
rvm gemset import #{gemset_filepath}

cp config/database.yml.sample config/database.yml
RAILS_GEM_VERSION=#{node[:rails][:version]} rake asset:packager:build_all
script/update_geoip
if [ ! -f 'bootstrapped' ] ; then
  echo "Bootstrapping shapado one time"
  RAILS_ENV=#{node[:rails][:environment]} RAILS_GEM_VERSION=#{node[:rails][:version]} rake bootstrap
  touch bootstrapped
else
  echo "Shapado has already been boostrapped, skipping the bootstrap command"
fi
# Ignore errors/warnings from rake bootstrap, cause it complains a lot
exit 0
  EOF
end

# In v3.10.6 & HEAD this css file is not generated properly, maybe we can remove this one day?
remote_file ::File.join(shapado_install_dir, "public", "stylesheets", "base_packaged.css") do
  source "base_packaged.css"
end

unicorn_app "shapado" do
  app_name "shapado"
  app_path shapado_install_dir
  cookbook "shapado"
  template "unicorn.rb.erb"
end

nginx_enable_vhost node[:shapado][:fqdn] do
  cookbook "shapado"
  template "nginx.conf.erb"
  fqdn node[:shapado][:fqdn]
  aliases node[:shapado][:aliases]
  shapado_path shapado_install_dir
  create_doc_root false
end