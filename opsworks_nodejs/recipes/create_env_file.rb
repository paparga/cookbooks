message "\n\n\nStarting Node\n\n"
node[:deploy].each do |application, deploy|
  template File.join(deploy[:deploy_to], "shared","app.env") do
    source "app.env.erb"
    mode 0770
    owner deploy[:user]
    group deploy[:group]
    variables(
      :environment => OpsWorks::Escape.escape_double_quotes(deploy[:environment_variables].merge({FOO: 'BAR'}))
    )

    message "\n\n\nDEPLOY: #{deploy.inspect}"
    Chef::Log.debug("\n\n\nDEPLOY: #{deploy.inspect}")


    message "\n\n\nEnvironment: #{OpsWorks::Escape.escape_double_quotes(deploy[:environment_variables].merge({FOO: 'BAR'}))}"

    Chef::Log.debug("\n\n\nEnvironment: #{OpsWorks::Escape.escape_double_quotes(deploy[:environment_variables].merge({FOO: 'BAR'}))}")

    only_if {File.exists?("#{deploy[:deploy_to]}/shared")}
  end
end
