node[:deploy].each do |application, deploy|
  pathname = File.join(deploy[:deploy_to], "shared","app.env")
  File.open(pathname, 'a') do |f|
    f.puts 'export AIRPAIR_CLI=ROCKS'
  end
end
