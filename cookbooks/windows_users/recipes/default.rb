#
# Cookbook Name:: windows_users
# Recipe:: default
#
# Copyright 2012, City Index Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Super admins get access to everything
super_admins = data_bag('super_admins')
 
super_admins.each do |username|
  super_admin = data_bag_item('super_admins', username)
  
  user(username) do
  	password super_admin['password']
  end
  windows_batch "Add #{username} to load administrators group" do
    code <<-EOH
    for /f "Tokens=*" %%a in ('net localgroup administrators^|find /i "#{username}"') do goto end
    net localgroup administrators #{username} /add
    : end
    EOH
  end
  
end

#And the principal role_admins also get access (pricipal is defined as the first one)
role_admins = data_bag("#{node['roles'][0]}_admins")
 
role_admins.each do |username|
  role_admin = data_bag_item("#{node['roles'][0]}_admins", username)
   
  user(username) do
  	password role_admin['password']
  end
  windows_batch "Add #{username} to load administrators group" do
    code <<-EOH
    for /f "Tokens=*" %%a in ('net localgroup administrators^|find /i "#{username}"') do goto end
    net localgroup administrators #{username} /add
    : end
    EOH
  end
end