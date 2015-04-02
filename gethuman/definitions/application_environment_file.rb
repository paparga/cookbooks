define :application_environment_file, path: './', environment_variables: Hash.new do
  Chef::Log.warn "application_environment_file"

  template File.join(params[:path], 'shared','app.env') do
    cookbook 'gethuman'
    source   'app.env.erb'

    user  deploy[:user]
    owner deploy[:user]
    group deploy[:group]

    variables(environment_variables: params[:environment_variables])

    only_if { File.exists? File.join(path, 'shared') }
  end
end
