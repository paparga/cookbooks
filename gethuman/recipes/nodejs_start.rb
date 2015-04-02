Chef::Log.warn "gethuman::nodejs_start\n NODE ENV VARIAbLES: #{node['environment_variables']}"

node['deploy'].each do |application, deploy|
  execute "restart Node app #{application} for custom env" do
    action :nothing

    user deploy['user']
    cwd deploy['current_path']

    environment ({'SNUGGSHOME' => '/home/myhome'})

    # Nodejs start command
#   command "#{deploy['deploy_to']}/path/to/node"
    command "echo WAT!"
  end
end
