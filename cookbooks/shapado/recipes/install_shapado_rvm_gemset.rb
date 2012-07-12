#
# Cookbook Name:: shapado
# Recipe:: default
#
#  OpsCode Chef Cookbooks
#  Copyright 2011-2012 CityIndex Ltd.
#
#  This product includes software developed at
#    CityIndex Ltd. (http://www.cityindex.com)

rightscale_marker :begin

node[:rails][:version] = "2.3.11"
node['rvm']['default_ruby'] = 'ree-1.8.7-2011.03@shapado'
node['rvm']['gem_package']['rvm_string'] = 'ree-1.8.7-2011.03@shapado'

include_recipe "rvm::default"
include_recipe "rvm::gem_package"
include_recipe "nginx::install_from_package"
include_recipe "rails::install"
include_recipe "unicorn::install_unicorn"

shapado_install_dir = ::File.join(node[:nginx][:content_dir], "shapado")
gemset_file = "shapado-#{node[:shapado][:version]}.gems"
gemset_filepath = ::File.join(shapado_install_dir, gemset_file)

if(node[:shapado][:recaptcha_enable] == "true" && (node[:shapado][:recaptcha_public_key].empty? || node[:shapado][:recaptcha_private_key].empty?))
  raise "Recaptcha support for shapado was enabled, but the public or private API key was empty"
end

# Switch to the latest stable rubygems for Rails 2.3.x
rvm_shell "Switch to the latest stable rubygems for Rails 2.3.x" do
  ruby_string 'ree-1.8.7-2011.03@shapado'
  code "rvm rubygems 1.3.7"
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

rvm_shell "Bootstrap shapado" do
  ruby_string 'ree-1.8.7-2011.03@shapado'
  cwd ::File.join(node[:nginx][:content_dir], "shapado")
  code <<-EOF
rvm gemset import #{gemset_filepath}

#rake gems:install

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
cookbook_file ::File.join(shapado_install_dir, "public", "stylesheets", "base_packaged.css") do
  source "base_packaged.css"
  backup false
end

unicorn_app "shapado" do
  app_name "shapado"
  app_path shapado_install_dir
  cookbook "shapado"
  template "unicorn.rb.erb"
  # This is totally hard coded, and maybe we should try a little harder to find it dynamically?
  unicorn_rails_bin '/usr/local/rvm/gems/ree-1.8.7-2011.03@shapado/bin/unicorn_rails'
end

nginx_enable_vhost node[:shapado][:fqdn] do
  cookbook "shapado"
  template "nginx.conf.erb"
  fqdn node[:shapado][:fqdn]
  aliases node[:shapado][:aliases]
  shapado_path shapado_install_dir
  create_doc_root false
end

rightscale_marker :end