#
# Cookbook Name:: nodejs-0.12.0-wrapper
# Recipe:: default
#
# Copyright (C) 2015 Dimitar Pavlov
#
# All rights reserved - Do Not Redistribute
#

# total hack since I don't have anyplace better to put this
include_recipe 'imagemagick'

#include_recipe 'nodejs::iojs'
include_recipe 'nodejs'
include_recipe 'nodejs::nodejs_from_binary'
