PM2_VERSION = node['pm2']['version']

Chef::Log.warn "\n\n\n BeforeRunning gethuman::nodejs"
Chef::Log.warn node[:platform]
Chef::Log.warn PM2_VERSION

include_recipe 'nodejs::nodejs_from_binary'

# Install pm2
nodejs_npm 'pm2' do
  version PM2_VERSION if PM2_VERSION
end

node['deploy'].each do |application, deploy|
  if deploy[:application_type] != 'nodejs'
    Chef::Log.debug("Skipping deploy::nodejs-restart for application #{application} as it is not a node.js app")
    next
  end

  execute "restart node.js application #{application}" do
    command = "/usr/local/bin/pm2 start #{deploy['deploy_to']}/releases/current/server.js"
#   Chef::Log.warn("stop node.js via: #{node[:deploy][application][:nodejs][:stop_command]}")

    Chef::Log.warn("restart node.js via: #{command}")

    Chef::Log.warn(`#{command}`)
#   Chef::Log.warn(`ls -al #{deploy['deploy_to']}/releases/current`)
    Chef::Log.warn(`/usr/local/bin/pm2 list`)
    $? == 0
  end

# pm2_application 'gethuman' do
#   script 'server.js'
#   cwd deploy['deploy_to']
#   action [:deploy, :start_or_restart]
# end
end

# Chef::Log.info(`#{node[:deploy][application][:nodejs][:restart_command]}`)
Chef::Log.warn "After Running gethuman::nodejs \n\n\n"
