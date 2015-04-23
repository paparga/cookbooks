define :application_environment_file, path: './', user: '', group: '', environment_variables: Hash.new do
  Chef::Log.warn "application_environment_file"

  template File.join(params[:path], 'shared','app.env') do
    cookbook 'gethuman'
    source   'app.env.erb'

    user  params['user']
    owner params['user']
    group params['group']

    variables(environment_variables: params[:environment_variables])

    only_if { File.exists? File.join(path, 'shared') }
  end
end
