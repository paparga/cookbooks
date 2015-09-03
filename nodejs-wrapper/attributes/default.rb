
# Override node the version
default['nodejs']['engine'] = 'iojs'
default['nodejs']['version'] = '3.2.0'
# default['nodejs']['install_method'] = 'binary'

default["nodebin"]["location"] = '/usr/bin/node'
default["nodebin"]["opsworks_location"] = '/usr/local/bin/node'
