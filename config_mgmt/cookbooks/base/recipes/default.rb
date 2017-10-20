#
# Cookbook:: base
# Recipe:: default configuration
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#

extend BaseLib::WSL

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
package 'unzip'
package 'zip'

#############################################################################
# Virtualization for Test Kitchen

if is_WSL?
  reqd_choco_pkgs = [ 'docker', 'virtualbox' ]
  local_pkgs = choco_pkgs_locally_installed
  pkg_match = 0
  reqd_choco_pkgs.each do |pkg_name|
    pkg_match+=1 if local_pkgs.key?(pkg_name)
  end

  if pkg_match < reqd_choco_pkgs.length
		# WSL does not support Linux versions of these packages.
		# Chef doesn't test for WSL, so it thinks the node is Linux and can't use
		# the chocolatey_package resource.
		puts ''
		puts 'WSL does not support Linux versions of some virtualization tools. These will need to be'
		puts 'installed in Windows. The following steps are recommended:'
		puts '1) Install the chocolatey package manager.'
		puts '2) Then, from an Administrator-elevated Windows command prompt:'
    reqd_choco_pkgs.each do |pkg_name|
			unless local_pkgs.key?(pkg_name)
				puts "  choco install #{pkg_name}"
			end
		end
		puts ''
	end

	if local_pkgs.key?("virtualbox")
		# Install WSL-friendly version of Vagrant.
		version = "2.0.0"
		arch = "x86_64"
		remote_file "/tmp/vagrant_#{version}_#{arch}.deb" do
			source "https://releases.hashicorp.com/vagrant/#{version}/vagrant_#{version}_#{arch}.deb"
			mode 0644
		end

		dpkg_package "vagrant" do
			source "/tmp/vagrant_#{version}_#{arch}.deb"
			action :install
		end
	end
end

unless is_WSL?
  package 'docker'
  package 'virtualbox'
  package 'vagrant'
end

#############################################################################
# Install build tools
package 'build-essential'

#############################################################################
# Nice-to-haves
package 'tree' do
  ignore_failure true
end
