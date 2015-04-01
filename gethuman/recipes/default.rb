node[:deploy].each do |application, deploy|

  application_environment_file do
    merged_environment(deploy[:environment_variables])

    user deploy[:user]
    group deploy[:group]

    path ::File.join(deploy[:deploy_to], 'shared')
    environment_variables merged_environment(deploy[:environment_variables])
  end
end

def merged_environment(variables)
  custom = { :FOO => 'BAR', 'SNUGGS' => 'WINNING!' }
  custom.merge!(:WEB => 'LIFE')

  Chef::Log.fatal "\n\n\nAPPLICATION Environment FILE: #{custom.merge(variables)}"
  Chef::Log.fatal "\n\n\nNormal: #{normal.inspect}"

  custom.merge variables
end
