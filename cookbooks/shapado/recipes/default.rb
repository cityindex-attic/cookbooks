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

if(node[:shapado][:recaptcha_enable] && (!node[:shapado][:recaptcha_public_key] || node[:shapado][:recaptcha_private_key]))
  raise "Recaptcha support for shapado was enabled, but the public or private API key was empty"
end

# TODO: This mechanism for getting the arch is reused in my code a lot, need to either set a node attribute once
# somewhere, or otherwise encapsulate this, maybe ohai?
uname_machine = `uname -m`.strip

machines = {"x86_64" => "amd64", "i386" => "i386", "i686" => "i386"}
arch = machines[uname_machine]

Chef::Log.info "Detected system architecture of #{uname_machine} installing the #{arch} RVM gemset for Shapado..."

# Required for the "magic" gem
package "file"

shapado_install_dir = ::File.join(node[:nginx][:content_dir], "shapado")

git shapado_install_dir do
  repository "git://gitorious.org/shapado/shapado.git"
  revision node[:shapado][:version]
  action :sync
  not_if { ::File.directory?(shapado_install_dir) }
end

# TODO: This is a total hack, and this should become a distro package at some point
ree_global_gemset_path = ::File.join(node[:rvm][:install_path], "gems", "ree-#{node[:ruby_enterprise][:version]}")

remote_file "/tmp/gemset.tar.gz" do
  source "gemset-shapado-#{node[:shapado][:version]}-#{arch}.tar.gz"
end

bash "Extract gemset to ree global gemset" do
  code "tar -zxf /tmp/gemset.tar.gz -C #{ree_global_gemset_path}"
end

# TODO: Lots of good configuration bits like enabling social networking and google analytics
template ::File.join(shapado_install_dir, "config", "shapado.yml") do
  source "shapado.yml.erb"
  variables(:uri => node[:shapado][:fqdn])
end

bash "Install gems & bootstrap shapado" do
  cwd ::File.join(node[:nginx][:content_dir], "shapado")
  code <<-EOF
rvm_script="#{node[:rvm][:install_path]}/scripts/rvm"
echo "Testing for RVM using $rvm_script"
if [ ! -f $rvm_script ]
then
  echo "No RVM installation found, not loading RVM environment"
  exit 0
fi

if [[ -s "$rvm_script" ]] ; then
  echo "Found a default RVM environment, loading it now"
  source "$rvm_script"
else
  echo "No default RVM environment found, can not continue.  Try setting one with rvm --default"
  exit 0
fi

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
end