default[:cwlogs][:logfile] = '/srv/www/app/current/log/out.log'

include_recipe "logrotate"

logrotate_app "newrelic" do
  cookbook  "logrotate"
  path      "/srv/www/app/current/newrelic_agent.log"
  options   ["copytruncate", "missingok", "notifempty"],
  frequency "daily"
  rotate    7
end
