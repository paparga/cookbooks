Chef::Log.warn "\n\n\n Running gethuman::default"

package 'nginx'

include_recipe 'gethuman::ssl'
include_recipe 'gethuman::nginx'
include_recipe 'gethuman::caching'
include_recipe 'gethuman::nodejs_start'
include_recipe 'gethuman::nodejs_stop'
include_recipe 'gethuman::environment'
