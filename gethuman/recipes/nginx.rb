#
# Cookbook Name:: gethuman
# Recipe:: nginx
# Author:: Rashaun "Snuggs" Stovall <rashaunstovall@gmail.com>
#
package 'nginx' do
  action :install
end

include_recipe 'nginx' # does this actuall

# include_recipe 'nginx::service' # do we even need this? It's defined on line 67 of nginx/recipes/default.rb
Chef::Log.warn "gethuman::nginx\n NODE ENV VARIAbLES: #{node['environment_variables']}"

node['deploy'].each do |application, deploy|
  cached_routes = deploy['cached_routes'] || node['cached_routes']
  force_default[:nginx][:cached_routes] = cached_routes

  Chef::Log.warn "nginx: #{node['nginx']}"

  # configure nginx
  configure_nginx do
    user deploy['user']
    group deploy['group']

    path File.join(node['nginx']['dir'], '/sites-enabled')
#   environment_variables Gethuman.merged_environment(deploy['environment_variables'], node['environment_variables'])
  end

  service 'nginx' do
    action [ :start, :enable ]
  end
end
