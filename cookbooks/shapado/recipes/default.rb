#
# Cookbook Name:: shapado
# Recipe:: default
#
#  OpsCode Chef Cookbooks
#  Copyright 2011 CityIndex Ltd.
#
#  This product includes software developed at
#    CityIndex Ltd. (http://www.cityindex.com)

node[:rails][:version] = "2.3.10"

include_recipe "nginx::default"
include_recipe "ruby_enterprise::default"
include_recipe "rails::install"
include_recipe "unicorn::enterprise"

git ::File.join(node[:nginx][:content_dir], "shapado") do
  repository "git://gitorious.org/shapado/shapado.git"
  action :sync
end

bash "Install gems & bootstrap shapado" do
  cwd ::File.join(node[:nginx][:content_dir], "shapado")
  code <<-EOF
rake gems:install
rake asset:packager:build_all
script/update_geoip
rake bootstrap RAILS_ENV=development
touch cheffed
  EOF
  creates ::File.join(node[:nginx][:content_dir], "shapado", "cheffed")
end