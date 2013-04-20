#
# Cookbook Name:: Opsview/ Nagios
# Recipe:: default
#
# Copyright 2013, Adelphic Inc.
#
# All rights reserved - Do Not Redistribute
#
# Template

#########################################
if platform?("amazon")
	
cookbook_file "/tmp/opsview-agent-4.3.2.224-1.el6.x86_64.rpm" do
  source "opsview-agent-4.3.2.224-1.el6.x86_64.rpm"
  mode 00700
  owner "root"
  group "root"
  backup false
end

execute "Install_opsview_agent" do
    command "cd /tmp/ && rpm -i opsview-agent-4.3.2.224-1.el6.x86_64.rpm"
    not_if "test -e /tmp/opsview-agent-4.3.2.224-1.el6.x86_64.rpm"
end

end


###################################################

if platform?("ubuntu")

cookbook_file "/tmp/opsview-agent_4.3.2.224-1precise1_amd64.deb" do
  source "opsview-agent_4.3.2.224-1precise1_amd64.deb"
  mode 00700
  owner "root"
  group "root"
  backup false
end

execute "Install_opsview_agent" do
    command "cd /tmp/ && dpkg -i opsview-agent_4.3.2.224-1precise1_amd64.deb"
    not_if "test -e /tmp/opsview-agent_4.3.2.224-1precise1_amd64.deb"
end


end
##########################################################

