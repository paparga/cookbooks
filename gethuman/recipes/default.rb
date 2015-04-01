# Chef::Log.fatal("\n\n\n(Chef) GETHUMAN RECIPE DEFAULT:#{node.inspect}")

node[:deploy].each do |application, deploy|

# opsworks_deploy_dir do
#   user deploy[:user]
#   group deploy[:group]
#   path deploy[:deploy_to]
# end

# opsworks_deploy do
#   deploy_data deploy
#   app application
# end

# opsworks_nodejs do
#   deploy_data deploy
#   app application
# end

Chef::Log.fatal("\n\n\n(CHEF)NODE DEPLOY: #{deploy.inspect}")
  application_environment_file do
    user deploy[:user]
    group deploy[:group]
    path ::File.join(deploy[:deploy_to], "shared")
    Chef::Log "\n\n\nAPPLICATION Environment FILE: #{deploy[:environment_variables].merge!({FOO: 'BAR'})}"
    environment_variables deploy[:environment_variables]
  end

# ruby_block "restart node.js application #{application}" do
#   block do
#     Chef::Log.info("restart node.js via: #{node[:deploy][application][:nodejs][:restart_command]}")
#     Chef::Log.info(`#{node[:deploy][application][:nodejs][:restart_command]}`)
#     $? == 0
#   end
# end
end
