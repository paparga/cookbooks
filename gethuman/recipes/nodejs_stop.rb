Chef::Log.warn "gethuman::nodejs_stop\n NODE ENV VARIAbLES: #{node['environment_variables']}"

node['deploy'].each do |application, deploy|
  execute "restart Node app #{application} for custom env" do
    action :nothing

    user deploy['user']
    cwd deploy['current_path']

    # Nodejs stop command
#   command "#{deploy['deploy_to']}/path/to/node"
    command "echo WAT!"
  end
end
