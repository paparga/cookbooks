Chef::Log.warn "gethuman::logger\n NODE ENV VARIAbLES: #{node['environment_variables']}"

node['deploy'].each do |application, deploy|
  execute "send #{application} logs to CloudWatch" do
    action :nothing

    user deploy['user']
    cwd deploy['current_path']
  end
end
