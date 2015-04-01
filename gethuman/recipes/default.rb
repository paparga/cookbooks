node[:deploy].each do |application, deploy|

  custom = { :FOO => 'BAR', 'SNUGGS' => 'WINNING!' }

  Chef::Log.fatal("\n\n\n(CHEF)NODE DEPLOY: #{deploy.inspect}")
  Chef::Log.fatal "\n\n\nAPPLICATION Environment FILE: #{deploy[:environment_variables].merge(custom)}"

  application_environment_file do
    user deploy[:user]
    group deploy[:group]

    path ::File.join(deploy[:deploy_to], 'shared')

    environment_variables deploy[:environment_variables].merge(custom)
  end
end
