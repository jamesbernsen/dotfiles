# # encoding: utf-8

# Inspec test for recipe base::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe package('curl') do
  it { should be_installed }
end

describe package('git') do
  it { should be_installed }
end

describe package('zip') do
  it { should be_installed }
end

describe package('unzip') do
  it { should be_installed }
end

if node['os_version'].include? "Microsoft"
  # WSL does not support VirtualBox and Vagrant
else
  describe package('docker') do
    it { should be_installed }
  end

  describe package('virtualbox') do
    it { should be_installed }
  end

  describe package('vagrant') do
    it { should be_installed }
  end
end

describe package('build_essential') do
  it { should be_installed }
end

describe package('tree') do
  it { should be_installed }
end
