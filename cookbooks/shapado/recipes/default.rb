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
include_recipe "ruby_enterprise::rvm_packaged"
include_recipe "rails::install"
include_recipe "unicorn::enterprise"

# TODO: This mechanism for getting the arch is reused in my code a lot, need to either set a node attribute once
# somewhere, or otherwise encapsulate this, maybe ohai?
uname_machine = `uname -m`.strip

machines = {"x86_64" => "amd64", "i386" => "i386", "i686" => "i386"}
arch = machines[uname_machine]

Chef::Log.info "Detected system architecture of #{uname_machine} installing the #{arch} RVM gemset for Shapado..."

# Required for the "magic" gem
package "file"

shapado_install_dir = ::File.join(node[:nginx][:content_dir], "shapado")

# TODO: Need to grab a specific branch/tag
git shapado_install_dir do
  repository "git://gitorious.org/shapado/shapado.git"
  revision node[:shapado][:version]
  action :sync
end

# TODO: This is a total hack, and this should become a distro package at some point
ree_global_gemset_path = ::File.join(node[:rvm][:install_path], "gems", "ree-#{node[:ruby_enterprise][:version]}")

remote_file "/tmp/gemset.tar.gz" do
  source "gemset-shapado-#{node[:shapado][:version]}-#{arch}.tar.gz"
end

bash "Extract gemset to ree global gemset" do
  code "tar -zxf /tmp/gemset.tar.gz -C #{ree_global_gemset_path}"
end

# In v3.10.6 & HEAD this css file is not generated properly, maybe we can remove this one day?
remote_file ::File.join(shapado_install_dir, "public", "stylesheets", "base_packaged.css") do
  source "base_packaged.css"
end

# TODO: Lots of good configuration bits like enabling social networking and google analytics
template ::File.join(shapado_install_dir, "config", "shapado.yml") do
  source "shapado.yml.erb"
  variables(:uri => node[:shapado][:fqdn])
end

bash "Install gems & bootstrap shapado" do
  cwd ::File.join(node[:nginx][:content_dir], "shapado")
  code <<-EOF
cp config/database.yml.sample config/database.yml
RAILS_GEM_VERSION=#{node[:rails][:version]} rake asset:packager:build_all
script/update_geoip
RAILS_ENV=#{node[:rails][:environment]} RAILS_GEM_VERSION=#{node[:rails][:version]} rake bootstrap
touch cheffed
  EOF
  creates ::File.join(node[:nginx][:content_dir], "shapado", "cheffed")
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