#
# Cookbook Name:: pm2
# Recipe:: default

# Constants
PM2_VERSION = node['pm2']['version']

# Install npm
include_recipe 'pm2::nodejs'

# Install pm2
nodejs_npm 'pm2' do
  version PM2_VERSION unless PM2_VERSION.nil?
end

node['deploy'].each do |application, deploy|
  if deploy[:application_type] != 'nodejs'
    Chef::Log.debug("Skipping deploy::nodejs-restart for application #{application} as it is not a node.js app")
    next
  end

  pm2_application 'server' do
    dir = "#{deploy['deploy_to']}/current/"
    cwd dir
    script 'server.js'

    action [:deploy, :start_or_restart]
  end
end
