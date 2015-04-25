#
# Cookbook Name:: pm2
# Recipe:: nodejs
#
# Copyright 2015, Mindera
#

# stop currently running nodejs

node['deploy'].each do |application, deploy|
  ruby_block "stop node.js application #{application}" do
    block do
      Chef::Log.info("stop node.js via: #{node[:deploy][application][:nodejs][:stop_command]}")
      Chef::Log.info(`#{node[:deploy][application][:nodejs][:stop_command]}`)
      $? == 0
    end
  end

  file "#{node[:monit][:conf_dir]}/node_web_app-#{application}.monitrc" do
    action :delete
    only_if do
      ::File.exists?("#{node[:monit][:conf_dir]}/node_web_app-#{application}.monitrc")
    end
  end
end

# Install nodejs
include_recipe 'nodejs::nodejs_from_binary'
