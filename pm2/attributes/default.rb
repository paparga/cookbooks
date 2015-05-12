#
# Cookbook Name:: pm2
# Attributes:: default
#
# Copyright 2015, Mindera
#

default_unless['pm2']['version'] = nil


# set value for env vars  node[:deploy]['app'][:environment_variables]

layers = node[:opsworks][:instance][:layers]

if layers.include?("api-layer")
    default[:deploy]["app"][:environment_variables]["CONTAINER"] = "api"
elsif layers.include?("web-layer")
    default[:deploy]["app"][:environment_variables]["CONTAINER"] = "web"
end
