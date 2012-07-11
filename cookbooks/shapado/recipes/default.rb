#
# Cookbook Name:: shapado
# Recipe:: default
#
#  OpsCode Chef Cookbooks
#  Copyright 2012 CityIndex Ltd.
#
#  This product includes software developed at
#    CityIndex Ltd. (http://www.cityindex.com)
#

rightscale_marker :begin

node['rvm']['default_ruby'] = 'ree-1.8.7-2011.03@shapado'
node['rvm']['gem_package']['rvm_string'] = 'ree-1.8.7-2011.03@shapado'

rightscale_marker :end