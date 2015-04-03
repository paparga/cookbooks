Chef::Log.warn "gethuman::nginx\n NODE ENV VARIAbLES: #{node['environment_variables']}"

node['deploy'].each do |application, deploy|
# http://wiki.nginx.org/CommandLine#Stopping_or_Restarting_Nginx
  Chef::Log.warn "nginx: #{node['nginx']}"
  system("echo SNUGGS IN DA HOUSE!")

  execute "List shared dr" do
    system("ls -al #{deploy['deploy_to']}/shared")
    command "ls -al #{deploy['deploy_to']}/shared"
  end

  execute "stop nginx" do
    pid = "/usr/local/var/run/nginx.pid"

    Chef::Log.warn "stopping nginx: #{pid}"
    system("sudo kill -QUIT $( cat #{pid} )")
  end

  execute "start nginx" do
    start = "sudo nginx"

    Chef::Log.warn "starting nginx:"
    system start
  end
end
