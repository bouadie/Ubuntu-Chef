#
# Cookbook Name:: Route53 AWS DNS
# Recipe:: default
#
# Copyright 2013, Adelphic Inc.
#
# All rights reserved - Do Not Redistribute

if node['adelphiconfig']['route53']
AWS_ACCESS_KEY_ID = node.default_attrs['adelphiconfig']['route53']['AWS_ACCESS_KEY_ID']
AWS_SECRET_ACCESS_KEY = node.default_attrs['adelphiconfig']['route53']['AWS_SECRET_ACCESS_KEY']
ZONE= node.default_attrs['adelphiconfig']['route53']['ZONE']
TTL= node.default_attrs['adelphiconfig']['route53']['TTL']
else

  raise "route53 node DNS not defined for this node"

end

###############Route53 config dirs############
directory "/var/run/chef" do
  recursive false
  owner "root"
  group "root"
  mode 0700
end

template "/etc/hosts" do
        source "hosts.erb"
        mode "0644"
        backup false
        owner "root"
        group "root"
end

cookbook_file "/etc/rc.d/rc.local" do
  source "rclocal"
  mode 00755
  owner "root"
  group "root"
  backup false
end

cookbook_file "/usr/bin/cli53" do
  source "cli53.erb"
  mode 00700
  owner "root"
  group "root"
  backup false
end

directory "/etc/route53" do
  recursive false
  owner "root"
  group "root"
  mode 0700
  not_if "test -e /etc/route53/config"
end

template "/etc/route53/config" do
        source "route53-config.erb"
        mode "0600"
        backup false
        owner "root"
        group "root"
        variables(
          :AWS_ACCESS_KEY_ID => "#{AWS_ACCESS_KEY_ID}",
          :AWS_SECRET_ACCESS_KEY => "#{AWS_SECRET_ACCESS_KEY}",
          :ZONE => "#{ZONE}",
          :TTL => "#{TTL}"
          )
end

template "/usr/sbin/update-route53-dns" do
        source "update-route53.erb"
        mode "0700"
        backup false
        owner "root"
        group "root"
end


##############################################

case node["platform"]
when "ubuntu","debian"

%w{ 
    python-setuptools 
    python-dev 
    build-essential 
    python-boto
    git-core
  }.each do |pkg|
     package pkg do
     action :install
     end
  end

execute "Install_ARGS" do
    command "cd /tmp/ && git clone git://github.com/boto/boto && cd boto && python setup.py install & easy_install dnspython argparse"
    not_if "test -e /tmp/boto"
end


cookbook_file "/etc/dhcp3/dhclient-enter-hooks.d/nodnsupdate" do
  source "nodnsupdate.erb"
  mode 00700
  owner "root"
  group "root"
  backup false
end

template "/etc/resolv.conf" do
        source "resolv_conf.erb"
        mode "0444"
        backup false
        owner "root"
        group "root"
end

#################### Amazon, Redhat, CentOS #####################################
when "redhat","fedora","centos","amazon"
%w{ 
    python-boto
    python-argparse
  }.each do |pkg|
     package pkg do
     action :install
     end
end

execute "Install_Python_DNS" do
    command "easy_install dnspython"
    not_if "test -e /usr/lib/python2.6/site-packages/dnspython-1.10.0-py2.6.egg"
    end

else

  raise "This cookbook requires Ubuntu/Redhat/Amazon/Centos"

end

##########################################
