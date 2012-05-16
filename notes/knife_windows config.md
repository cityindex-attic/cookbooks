On Win2008R2 EC2 server:

[Enable winrm](http://wiki.opscode.com/display/chef/Knife+Windows+Bootstrap)

As local Administrator from DOS prompt
 
   winrm quickconfig -q
   winrm set winrm/config/winrs @{MaxMemoryPerShellMB="300"}
   winrm set winrm/config @{MaxTimeoutms="1800000"}
   winrm set winrm/config/service @{AllowUnencrypted="true"}
   winrm set winrm/config/service/auth @{Basic="true"}

Open ports on EC2 firewall

Ports: 5985 - 5986	
Source IPs: 87.112.196.195/32

Allows bootstrapping:

    knife bootstrap windows winrm 177.71.182.250 -r "role[ciapi_latency_collector]" -x Administrator -P "_secret_"


Allows kicking off chef-client run from management workstation

    knife winrm 50.112.111.248 'chef-client -c c:/chef/client.rb' -m -x Administrator -P "_secret_"
