#
# Cookbook Name:: pm2
# Recipe:: default

# Constants
PM2_VERSION = node['pm2']['version']

# Install npm 0.12
# include_recipe 'pm2::nodejs'

# Install pm2
nodejs_npm 'pm2' do
  version PM2_VERSION unless PM2_VERSION.nil?
end

node['deploy'].each do |application, deploy|
  pm2_application 'server' do
    dir = "#{deploy['deploy_to']}/current/"
    cwd dir
    script 'server.js'

    action [:deploy, :start_or_restart]
  end
end
