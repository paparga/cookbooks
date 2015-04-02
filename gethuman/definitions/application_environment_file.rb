define :application_environment_file, environment_variables: Hash.new do
  Chef::Log.warn "application_environment_file"

  template File.join(deploy[:deploy_to], 'shared','app.env') do
    source 'app.env.erb'

    mode 0770

    user  deploy[:user]
    owner deploy[:user]
    group deploy[:group]

    variables environment_variables: params[:environment_variables]
    environment_variables params[:environment_variables]

    only_if { File.exists? "#{deploy[:deploy_to]}/shared" }
  end
end
