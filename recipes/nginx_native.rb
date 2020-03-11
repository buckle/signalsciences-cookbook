#
# Cookbook Name:: signalsciences
# Recipe:: nginx_native
#
# Copyright (C) 2019 Buckle, Inc
#
# All rights reserved - Do Not Redistribute
#


include_recipe 'bke_signalsciences::common'

# if auto_update is enabled package action will be set to upgrade
install_action = if node['bke_signalsciences']['nginx_native_module_auto_update']
                   :upgrade
                 else
                   :install
                 end

# installs the sigsci-agent package and pins version if agent_version is set
package 'nginx-module-sigsci-nxo' do
  unless node['bke_signalsciences']['nginx_native_module_version'].empty?
    version node['bke_signalsciences']['nginx_native_module_version']
  end
  action install_action
end

node.default['bke_signalsciences']['nginx_module_type'] = 'native'
