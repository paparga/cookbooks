define :configure_nginx, path: './', user: '', group: '', cached_routes: [] do
  Chef::Log.warn 'configure_nginx'

  template File.join(params[:path], '/gethuman.conf') do
    cookbook 'gethuman'
    source   'nginx.conf.erb'

    user  params['user']
    owner params['user']
    group params['group']
    variables({ cached_routes: params['cached_routes'] })
  end
end

define :start_nginx, binary: '/usr/sbin/nginx' do
  Chef::Log.warn 'starting nginx'

  system  "#{binary} start"
# command "#{binary} start"
end

define :stop_nginx, binary: '/usr/sbin/nginx' do
  Chef::Log.warn 'stopping nginx'

  system  "#{binary} -s stop"
# command "#{binary} -s stop"
end
