Chef::Log.warn "\n\n\n gethuman::environment\n NODE ENV VARIAbLES: #{node[:environment_variables]}"

node[:deploy].each do |application, deploy|
  Chef::Log.warn "\n\n\nNormal: #{deploy[:environment_variables]}"

  application_environment_file do
    user deploy[:user]
    group deploy[:group]

    path ::File.join(deploy[:deploy_to], 'shared')
    environment_variables merged_environment(deploy[:environment_variables])
  end
end

def merged_environment(variables)
  Chef::Log.warn "app.env: #{variables.merge(node_environment_variables)}"

  variables.merge node_envirionment_variables
end

def node_environment_variables
  node[:environment_variables]
end

