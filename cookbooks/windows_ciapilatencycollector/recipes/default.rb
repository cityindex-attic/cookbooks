#
# Cookbook Name:: windows_ciapilatencycollector
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

windows_package "City Index CIAPI Latency Collector" do
  source "http://ci.labs.cityindex.com:8080/job/CiapiLatencyCollector/ws/_setup/CiapiLatencyCollector.msi"
  options "/quiet"
  action :install
end

ciapilatencycollector_install_dir = "#{ENV['ProgramFiles(x86)']}\\City Index\\CIAPI Latency Collector"

windows_batch "Configure CiapiLatencyCollector" do
  code <<-EOH
  "#{ciapilatencycollector_install_dir}\\CiapiLatencyCollectorConfig.exe -username:XX870869 -password:password"
  EOH
end
