#
# Cookbook Name:: signalsciences
# Recipe:: agent
#
# Copyright (C) 2016 Signal Sciences Corp.
#
# All rights reserved - Do Not Redistribute
#
#

include_recipe 'bke_signalsciences::common'

if node['bke_signalsciences']['nginx_module_type'] == 'native'
  node.override['bke_signalsciences']['rpc_address'] = '/var/run/sigsci.sock'
end

if node['bke_signalsciences']['access_key'].empty? || node['bke_signalsciences']['secret'].empty?
  Chef::Log.warn("Signal Sciences access or secret key attributes aren't set, not installing agent")
  return
end

# if auto_update is enabled package action will be set to upgrade
install_action = if node['bke_signalsciences']['agent_auto_update']
                   :upgrade
                 else
                   :install
                 end

# installs the sigsci-agent package and pins version if agent_version is set
package 'sigsci-agent' do
  unless node['bke_signalsciences']['agent_version'].empty?
    version node['bke_signalsciences']['agent_version']
  end
  action install_action
  notifies :restart, 'service[sigsci-agent]', :delayed
end

directory '/etc/sigsci' do
  mode 0755
end

# Avoid installing this template and restarting the agent unnecessarily. We should be the only
# thing putting this template here unless the user manually created one. This block used to
# re-render the template and restart the agent every Chef run, which for us was 30m-1h and
# caused issues on CentOS 7.
unless ::File.exists?('/etc/sigsci/agent.conf')
  template '/etc/sigsci/agent.conf' do
    source 'agent.conf.erb'
    sensitive true
    mode 0644
    notifies :restart, 'service[sigsci-agent]', :immediately
  end
end

service 'sigsci-agent' do
  # workaround for chef-client 11 handling of upstart services
  if node['platform_family'] == 'rhel' && node['platform_version'] =~ /^6/
    provider Chef::Provider::Service::Upstart
  end
  if node['platform_family'] == 'debian' && node['platform_version'] =~ /^1[24]/
    provider Chef::Provider::Service::Upstart
  end
  action [:enable, :start]
end
