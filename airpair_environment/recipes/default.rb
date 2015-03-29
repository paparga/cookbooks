pathname = File.join(deploy[:deploy_to], "shared","app.env")
File.open(pathname, 'w+') do |f|
  f.puts 'export CLI_ROCKS=true'
end

