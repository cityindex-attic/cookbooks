#
# Cookbook Name:: windows_splunk
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

splunk_home = "C:\\Program Files\\SplunkUniversalForwarder"

#install forwarder package, enabling collection of standard windows metrics
windows_package "Universal Forwarder" do
  source "http://download.splunk.com/releases/4.3.2/universalforwarder/windows/splunkforwarder-4.3.2-123586-x64-release.msi"
  options "/qb AGREETOLICENSE=yes LAUNCHSPLUNK=1 SERVICESTARTTYPE=auto WINEVENTLOG_APP_ENABLE=1 WINEVENTLOG_SEC_ENABLE=1 WINEVENTLOG_SYS_ENABLE=1 WINEVENTLOG_FWD_ENABLE=1 WINEVENTLOG_SET_ENABLE=1 ENABLEADMON=1"
  action :install
end

#Copy over the SplunkStorm config
remote_directory "#{splunk_home}\\etc\\apps\\stormforwarder_03a1e658693e11e18d40123139335bf7" do
  source "stormforwarder_03a1e658693e11e18d40123139335bf7"
end

#Restart forwarder
windows_batch "Restart splunk forwarder" do
  code <<-EOH
  "#{splunk_home}\\bin\\splunk" restart
  EOH
end