## ------------------------------------------------------------------
## AGENT CONFIGURATION
# ------------------------------------------------------------------
# agent site keys
default['bke_signalsciences']['access_key'] = ''
default['bke_signalsciences']['secret'] = ''

# optional configuration settings
default['bke_signalsciences']['client_ip_header'] = ''

# attribute to pin agent version by default install latest
default['bke_signalsciences']['agent_version'] = ''

# enable to auto update agent as new versions become available
default['bke_signalsciences']['agent_auto_update'] = false

# allow override of agent listener socket
default['bke_signalsciences']['rpc_address'] = ''

# debug flags
default['bke_signalsciences']['debug'] = {
  'log-web-inputs' => 0,
  'log-web-outputs' => 0,
  'log-uploads' => 0,
}


## ------------------------------------------------------------------
## APACHE MODULE CONFIGURATION
## ------------------------------------------------------------------
# attribute to pin apache module version by default install latest
default['bke_signalsciences']['apache_module_version'] = ''
default['bke_signalsciences']['apache_module_path'] = '/etc/httpd/modules'
default['bke_signalsciences']['apache_module_conf_path'] = '/etc/httpd/conf.d'

# enable to auto update apache module as new versions become available
default['bke_signalsciences']['apache_module_auto_update'] = false

## ------------------------------------------------------------------
## NGINX MODULE CONFIGURATION
## ------------------------------------------------------------------
# set nginx_module_type to "native" to use the native nginx module
default['bke_signalsciences']['nginx_module_type'] = false
default['bke_signalsciences']['nginx_lua_module_version'] = ''
default['bke_signalsciences']['nginx_lua_module_auto_update'] = false
default['bke_signalsciences']['nginx_native_module_version'] = ''
default['bke_signalsciences']['nginx_native_module_auto_update'] = false

## ------------------------------------------------------------------
## INTERNAL CONFIG
## ------------------------------------------------------------------
# auto update configuration options
default['bke_signalsciences']['cache_refresh_interval'] = 3600 # seconds
default['bke_signalsciences']['cache_sentinel_file'] = '/tmp/sigsci-repo.next_cache_refresh'
