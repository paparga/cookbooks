module Gethuman
  def self.merged_environment(variables)
    Chef::Log.warn "Gethuman.merged_environment: #{variables.merge(node_environment_variables)}"

    OpsWorks::Escape.escape_double_quotes(
      variables.merge node_envirionment_variables
    )
  end

  def node_environment_variables
    node['environment_variables']
  end

  def self.npm_install(app_name, app_config, app_root_path, npm_install_options)
    if File.exists?("#{app_root_path}/package.json")
      Chef::Log.info("package.json detected. Running npm #{npm_install_options}.")
      Chef::Log.info(OpsWorks::ShellOut.shellout("sudo su - #{app_config[:user]} -c 'cd #{app_root_path} && npm #{npm_install_options}' 2>&1"))
    end
  end
end
