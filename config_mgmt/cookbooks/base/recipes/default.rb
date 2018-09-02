#
# Cookbook:: base
# Recipe:: default configuration
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#

extend BaseLib::WSL
require_relative '../libraries/tmux_helper'

tmux = Class.new.extend(Tmux)

#############################################################################
# Schedule a daily apt-get update
# Credit: https://stackoverflow.com/questions/9246786/how-can-i-get-chef-to-run-apt-get-update-before-running-other-recipes
execute "apt-get-update-periodic" do
  command "apt-get update"
  ignore_failure true
  only_if do
    !File.exists?('/var/lib/apt/periodic/update-success-stamp') ||
    File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 86400
  end
end


#############################################################################
# motd
# NOTE (JRB): Supports multiple Linux distributions
include_recipe 'motd::default'
motd '55-mymotd' do
  action [:create]
  cookbook 'base'
  source 'motd.erb'
end


#############################################################################
# Utilities (probably already preinstalled)
package 'curl'
package 'git'
package 'unzip'
package 'zip'

#############################################################################
# Git tool - hub
hub_ver = "2.5.1"
hub_arch = "linux-amd64"
hub_basename = "hub-#{hub_arch}-#{hub_ver}"
hub_pkg_name = "#{hub_basename}.tgz"

remote_file "/tmp/#{hub_pkg_name}" do
  source "https://github.com/github/hub/releases/download/v#{hub_ver}/#{hub_pkg_name}"
  mode 0644
  action :create_if_missing
end

execute 'extract_hub_pkg' do
  command "tar xzf #{hub_pkg_name}"
  cwd "/tmp"
end

bash "install_hub" do
  Chef::Log.info("Installing hub...")
  user 'root'
  cwd "/tmp/#{hub_basename}"
  code <<-END_CMDS
  ./install
  END_CMDS
  not_if "hub --version | grep #{hub_ver}"
end

#############################################################################
# Vim (probably already preinstalled)
package 'vim'

#############################################################################
# Virtualization for Test Kitchen

if is_WSL?
  reqd_choco_pkgs = [ 'docker', 'vagrant', 'virtualbox' ]
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

  # Require Windows-side virtualbox and vagrant
  if local_pkgs.key?('vagrant') && local_pkgs.key?('virtualbox')

    # WSL Vagrant version must match Windows Vagrant
    vagrant_ver = local_pkgs['vagrant']
    vagrant_arch = "x86_64"
    vagrant_pkg_name = "vagrant_#{vagrant_ver}_#{vagrant_arch}.deb"
    remote_file "/tmp/#{vagrant_pkg_name}" do
      source "https://releases.hashicorp.com/vagrant/#{vagrant_ver}/#{vagrant_pkg_name}"
      mode 0644
      action :create
      not_if "dpkg-query -W 'vagrant'"
    end

    dpkg_package "vagrant" do
      source "/tmp/#{vagrant_pkg_name}"
      action :install
      not_if "dpkg-query -W 'vagrant'"
    end
  end
end

unless is_WSL?
  package 'docker'
  package 'virtualbox'
  package 'vagrant'
end

## TODO (jrb): Need to perform additional steps?
# vagrant box add hashicorp/precise64
# vagrant box add bento/ubuntu-16.04
# vagrant box add ubuntu/xenial64

#############################################################################
# Install build tools
include_recipe 'build-essential::default'
package 'pkg-config'

#############################################################################
# Build latest Tmux

# Remove tmux package
package 'tmux' do
  action :remove
end

# Install tmux build dependencies
package 'libevent-dev'
package 'libncurses5-dev'

# Download and build tmux
tmux_ver = "2.5"
local_src_dir = "/usr/local/src"
tmux_src_dir = "#{local_src_dir}/tmux-#{tmux_ver}"
tmux_pkg_name = "tmux-#{tmux_ver}.tar.gz"

directory "#{local_src_dir}" do
  recursive true
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

remote_file "#{local_src_dir}/#{tmux_pkg_name}" do
  source "https://github.com/tmux/tmux/releases/download/#{tmux_ver}/#{tmux_pkg_name}"
  mode 0644
  action :create_if_missing
end

execute 'extract_tmux_pkg' do
  command "tar xzf #{tmux_pkg_name}"
  cwd "#{local_src_dir}"
  not_if { tmux.is_installed? && tmux.installed_ver == tmux_ver }
end

bash "build_tmux" do
  Chef::Log.info("Building tmux...")
  user 'root'
  cwd "#{tmux_src_dir}"
  code <<-END_CMDS
  ./configure
  make
  make install
  END_CMDS
  not_if { tmux.is_installed? && tmux.installed_ver == tmux_ver }
end

#############################################################################
# NodeJS and NPM packages
node.default['nodejs']['install_method'] = 'binary'
node.default['nodejs']['version'] = '8.11.4'
node.default['nodejs']['binary']['checksum'] = 'c69abe770f002a7415bd00f7ea13b086650c1dd925ef0c3bf8de90eabecc8790'
include_recipe "nodejs"

include_recipe "nodejs::npm"
npm_package "leasot"
npm_package "npx"

#############################################################################
# Nice-to-haves
package 'tree' do
  ignore_failure true
end

# For copy/paste from Tmux to clipboard with an X server
unless is_WSL?
  package 'xclip' do
    ignore_failure true
  end
end
