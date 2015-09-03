#
# Cookbook Name:: nodejs-0.12.0-wrapper
# Recipe:: default
#
# Copyright (C) 2015 Dimitar Pavlov
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'iojs'
include_recipe 'nodejs::nodejs_from_binary'
