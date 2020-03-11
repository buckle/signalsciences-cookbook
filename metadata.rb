name 'bke_signalsciences'
maintainer 'The Buckle, Inc'
maintainer_email 'wsdsysadmin@buckle.com'
license 'Apache-2.0'
description 'Installs/Configures signalsciences'
long_description 'Installs/Configures signalsciences'
version '0.1.4'
chef_version '>= 12'
issues_url 'https://github.com/buckle/signalsciences-cookbook/issues'
source_url 'https://github.com/buckle/signalsciences-cookbook'

%w( redhat centos ubuntu debian ).each do |os|
  supports os
end

depends 'apt'
