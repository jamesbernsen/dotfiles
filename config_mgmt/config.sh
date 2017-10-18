#!/usr/bin/env bash

# Installs initial configuration management software
# Arguments: none

#############################################################################
# Installs the specified version of ChefDK and performs a minimal
# configuration of the target users' chef repo.
#   Must have root authority
# Arguments:
#   $1 -  ChefDK version (eg. "2.1.11")
#############################################################################
install_chefdk() {
  local chefdk_ver="$1" && shift

  # Install and configure ChefDK
  curl https://omnitruck.chef.io/install.sh | bash -s -- -P chefdk -c stable -v ${chefdk_ver}
  local target_home=$(eval echo ~)
  mkdir -p ${target_home}/chef_repo/cookbooks
}


#############################################################################
# Main logic
#############################################################################
main () {
  install_chefdk "2.1.11"
}

main
