name 'base'
maintainer 'James Bernsen'
maintainer_email 'jrbtex@gmail.com'
license 'All Rights Reserved'
description 'Installs/Configures base'
long_description 'Installs/Configures base software for a personal development environment'
version '0.4.0'
chef_version '>= 12.1' if respond_to?(:chef_version)

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/base/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/base'
depends 'build-essential', '~> 8.0'
depends 'motd',            '~> 0.6'
depends 'nodejs',          '~> 5.0'
