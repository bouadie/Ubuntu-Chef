#
# Cookbook Name:: Monit
# Recipe:: default
#
# Copyright 2013, Adelphic Inc.
#
# All rights reserved - Do Not Redistribute

package "monit" do
  action :install
end

service "monit" do
  action :start
  enabled true
  supports [:start, :restart, :stop]
end

if platform?("ubuntu")
  cookbook_file "/etc/default/monit" do
    source "monit.default"
    owner "root"
    group "root"
    mode 0644
  end

template "/etc/monit/monitrc" do
    owner "root"
    group "root"
    mode 0700
    source 'monitrc.erb'
    notifies :restart, resources(:service => "monit"), :immediate
  end

end

if platform?("amazon")
 
template "/etc/monit.conf" do
    owner "root"
    group "root"
    mode 0700
    source 'monitrc.erb'
  end

end

directory "/usr/local/monit" do
  recursive false
  owner "root"
  group "root"
  mode 0700
end
