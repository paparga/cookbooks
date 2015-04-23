Chef::Log.warn "gethuman::environment\n NODE ENV VARIAbLES: #{node['environment_variables']}"

node['deploy'].each do |application, deploy|
  # TODO: should check if application environment file exists
  #       to not break the following spec
  #       https://github.com/aws/opsworks-cookbooks/blob/release-chef-11.10/opsworks_nodejs/specs/default_spec.rb#L27
# append_to_application_environment_file do
#   environment_variables Gethuman.merged_environment(deploy[:environment_variables])
# end

  application_environment_file do
    path deploy['deploy_to']
    environment_variables Gethuman.merged_environment(deploy['environment_variables'], node['environment_variables'])
  end
end
