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

#TODO:  need to pass in CIAPI endpoints & credentials on command line, rather than have to enter them
#       in modal popup
windows_package "City Index CIAPI Latency Collector v1.0.64" do
  source "http://ci.labs.cityindex.com:8080/job/CiapiLatencyCollector/ws/_setup/CiapiLatencyCollector.msi"
  options "/qb"
  action :install
end