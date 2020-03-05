#
# Cookbook Name:: signalsciences
# Recipe:: rhel
#
# Copyright (C) 2016 Signal Sciences Corp.
#
# All rights reserved - Do Not Redistribute
#

dist_release = node['platform_version'].gsub(/^(\d)\..*/, '\1')

# Set a default RPC address for agents running on CentOS >= 7 with the native module
node.default['bke_signalsciences']['rpc_address'] = 'unix:/var/run/sigsci.sock' if node['bke_signalsciences']['rpc_address'].empty? && node['bke_signalsciences']['nginx_module_type'] == 'native'

# workaround for apache httpd under systemd. Under systemd httpd runs with
# private tmp enabled by default so we can't see our unix domain socket.

if dist_release >= '7' && node['bke_signalsciences']['rpc_address'].empty?
  node.default['bke_signalsciences']['rpc_address'] = 'unix:/var/run/sigsci-lua'
end

template '/etc/yum.repos.d/sigsci-release.repo' do
  source 'yum.sigsci-release.repo.erb'
  variables 'dist_release' => dist_release
  notifies :run, 'execute[yum-makecache-sigsci_release]', :immediately
end

execute 'yum-makecache-sigsci_release' do
  command 'yum -q makecache -y --disablerepo=* --enablerepo=sigsci_*'
  action :nothing
end

# If auto update mode is enabled periodically clean the yum metadata cache
# for the sigsci repo only. How frequently this occurs is configured by
# the cache_refresh_interval attribute, by default we refresh hourly.
cache_refresh_interval = node['bke_signalsciences']['cache_refresh_interval']
cache_sentinel_file = node['bke_signalsciences']['cache_sentinel_file']

if node['bke_signalsciences']['agent_auto_update'] || node['bke_signalsciences']['apache_module_auto_update'] || node['bke_signalsciences']['nginx_lua_module_auto_update'] || node['bke_signalsciences']['nginx_native_module_auto_update']
  script 'yum-expire_cache-sigsci_release_repo' do
    interpreter 'bash'
    code <<-EOS
    yum -q clean --disablerepo=* --enablerepo=sigsci_release expire-cache
    NOW=$(date "+%s")
    NEXT_REFRESH=$(( $NOW + #{cache_refresh_interval} ))
    echo $NEXT_REFRESH > #{cache_sentinel_file}
    EOS
    only_if "[ ! -f #{cache_sentinel_file} ] || [ $(date +%s) -gt $(cat #{cache_sentinel_file}) ]"
  end
end
