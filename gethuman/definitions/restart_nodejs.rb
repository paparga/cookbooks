define :restart_nodejs, application: nil do
  Chef::Log.warn 'restart_nodejs'

# notifies :run, resources(execute: "restart Node app #{params[:application]} for custom env"), :immediately
end

