Chef::Log.warn "gethuman::nginx\n NODE ENV VARIAbLES: #{node['environment_variables']}"

node['deploy'].each do |application, deploy|
  Chef::Log.warn "nginx: #{node['nginx']}"
  system("echo SNUGGS IN DA HOUSE!")

  execute "List shared dr" do
    system("ls -al #{deploy['deploy_to']}/shared")
    command "ls -al #{deploy['deploy_to']}/shared"
  end
end
