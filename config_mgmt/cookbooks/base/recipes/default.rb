#
# Cookbook:: base
# Recipe:: default configuration
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#

#############################################################################
# Schedule a daily apt-get update
execute "apt-get-update-periodic" do
  command "apt-get update"
  ignore_failure true
  only_if do
    File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
    File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 86400
  end
end


############################################################################i
# Utilities (probably already preinstalled)
package 'curl'
package 'git'

#############################################################################
# Chef dependencies
package 'vagrant'

#############################################################################
# Install build tools
package 'build-essential'

#############################################################################
# Nice-to-haves
package 'tree' do
  ignore_failure true
end
