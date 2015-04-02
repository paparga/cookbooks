Chef::Log.warn "\n\n\n Running gethuman::default"

if node[:opsworks][:instance][:layers]
  .include?("#{deploy[:application_type]}-app")

  include_recipe "gethuman::configure"
  include_recipe "gethuman::log"
end
