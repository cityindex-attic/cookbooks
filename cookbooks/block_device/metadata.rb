maintainer       "Ryan J. Geyer"
maintainer_email "me@ryangeyer.com"
license          "All rights reserved"
description      "Overrides the primary and secondary backup recipes to properly provide mongo data consitency"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

recipe "block_device::do_primary_backup", :description => "Creates a primary backup in the local cloud where the server is currently running.", :thread => 'block_backup'

recipe "block_device::do_secondary_backup", :description => "Creates a secondary backup to the remote cloud specified by block_device/secondary provider", :thread => 'block_backup'

all_recipes = [
  "block_device::do_primary_backup",
  "block_device::do_secondary_backup"
]

attribute "block_device/devices_to_use",
  :display_name => "Block Device(s) to Operate On",
  :description => "The block device(s) to operate on. Can be a comma-separated list of device names or '*' to indicate all devices. Example: device1",
  :required => "recommended",
  :default => "device1",
  :recipes => all_recipes

attribute "block_device/devices/default/backup/rackspace_snet",
  :display_name => "Rackspace SNET Enabled for Backup",
  :description => "When 'true', Rackspace internal private networking (preferred) is used for communications between servers and Rackspace Cloud Files. Ignored for all other clouds.",
  :type => "string",
  :required => "optional",
  :choice => ["true", "false"],
  :default => "true",
  :recipes => all_recipes

# Multiple Block Devices
device_count = 2
devices = 1.upto(device_count).map {|number| "device#{number}"}

# Set up the block device attributes for each device
devices.sort.each_with_index.map do |device, index|
  [device, index + 1]
end.each do |device, number|
  grouping "block_device/devices/#{device}",
    :title => "Block Device #{number}",
    :description => "Attributes for the block device: #{device}."

  attribute "block_device/devices/#{device}/backup/lineage",
    :display_name => "Backup Lineage (#{number})",
    :description => "The name associated with your primary and secondary database backups. It's used to associate them with your database environment for maintenance, restore, and replication purposes. Backup snapshots will automatically be tagged with this value (e.g. rs_backup:lineage=mysqlbackup). Backups are identified by their lineage name. Note: For servers running on Rackspace, this value also indicates the Cloud Files container to use for storing primary backups. If a Cloud Files container with this name does not already exist, one will automatically be created.",
    :required => device != 'device2' ? 'required' : 'optional',
    :recipes => all_recipes

  attribute "block_device/devices/#{device}/backup/primary/keep/daily",
    :display_name => "Keep Daily Backups (#{number})",
    :description => "The number of daily primary backups to keep (i.e., rotation size).",
    :required => "optional",
    :default => "14",
    :recipes => all_recipes

  attribute "block_device/devices/#{device}/backup/primary/keep/weekly",
    :display_name => "Keep Weekly Backups (#{number})",
    :description => "The number of weekly primary backups to keep (i.e., rotation size).",
    :required => "optional",
    :default => "6",
    :recipes => all_recipes

  attribute "block_device/devices/#{device}/backup/primary/keep/monthly",
    :display_name => "Keep Monthly Backups (#{number})",
    :description => "The number of monthly primary backups to keep (i.e., rotation size).",
    :required => "optional",
    :default => "12",
    :recipes => all_recipes

  attribute "block_device/devices/#{device}/backup/primary/keep/yearly",
    :display_name => "Keep Yearly Backups (#{number})",
    :description => "The number of yearly primary backups to keep (i.e., rotation size).",
    :required => "optional",
    :default => "2",
    :recipes => all_recipes
end