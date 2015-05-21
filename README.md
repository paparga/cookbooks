# GetHuman AWS OpsWorks Cookbooks

A collection of cookbooks used by GetHuman for some deployments. We tried to set this up in a generic
way so it actually could be used by anyone. At a high level, these cookbooks work on top of the
default AWS OpsWorks cookbooks. Anything GetHuman-specific has been abstracted out into environment
variables that can be set at the App level in an OpsWorks stack. The information in this README
includes:

* Dev Setup - Setup for dev that want to modify cookbooks
* Requirements - Project requirements to use these cookbooks
* Recipes - A description of the recipes in this repo
* ToDos - Stuff I haven't gotten to yet, but is on the agenda

## Dev Setup

Do these first

1. Install ruby
1. gem install foodcritic
1. brew install Caskroom/cask/chefdk
  * Note: this will install [Berkshelf](http://berkshelf.com/)

## Requirements

These recipes are meant to be used on AWS OpsWorks for an app that meets the following criteria:

* Only one app that needs to be called 'App' when created, but then can be changed (i.e. so short name remains simply 'app')
* Put env variables at app level. You can, however, add additional environment variables within the deploy script.
* If you are using an API and Web off of the same app, you will need to assign the following short names to the layers:
    * api-layer
    * web-layer
    
The layers are explicitly named that way because the pm2 cookbook will add an environment variable of CONTAINER with
either 'web' or 'api' as appropriate according to the layer name. If you don't care about this environment variable,
then ignore this part.

## Recipes

You will need to use a custom layer within OpsWorks. Then include these recipes:

* **setup** - logs::config, logs::install, nodejs-wrapper, nodejs-wrapper::create-symlink
* **configure** - opsworks_nodejs::configure, nodejs-wrapper::binary
* **deploy** - deploy::nodejs, pm2
* **undeploy** - deploy::nodejs-undeploy
* **shutdown** - deploy::nodejs-stop, nginx::stop

#### nodejs-wrapper

There are two changes that needed to be made from the [original repo](https://github.com/zupper/nodejs-wrapper-opsworks).
First, in attributes/default.rb, we needed to set the following:

```
default['nodejs']['version'] = '0.12.2'
default["nodebin"]["location"] = '/usr/bin/node'
default["nodebin"]["opsworks_location"] = '/usr/local/bin/node'
```

Then in recipes/default.rb we changed the following:

```
# for some reason, won't work unless we call both
include_recipe 'nodejs'
include_recipe 'nodejs::nodejs_from_binary'
```

This recipe wraps the nodejs cookbook and basically installs our desired version of Node.js (or io.js) on
OpsWorks. The create-symlink recipe is called right after the node install in order to create a symlink
from the place where OpsWorks expects node to be (i.e. /usr/local/bin/node) to the 
installed version from the nodejs recipe (i.e. /usr/bin/node).

Final note is that the nodejs-wrapper::binary recipe seems to be redundant but there is some weird
issue where it doesn't set up the right version unless we call nodejs_from_binary twice. TODO: fix this hack

#### logs

We are using a [shared logging cookbook](https://github.com/awslabs/opsworks-cloudwatch-logs-cookbooks) to
set up a CloudWatch agent on the servers in order to capture logs. 
[This article](http://blogs.aws.amazon.com/application-management/post/TxTX72HFKVS9W9/Using-Amazon-CloudWatch-Logs-with-AWS-OpsWorks)
explains what is going on. 

Note that this is not working yet. Need work here to figure it out.

#### opsworks_nodejs::configure

This is used to create a script which will set some local variables in the OpsWorks linux shell. We did not
configure this at all and it is exactly what exists in the [OpsWorks cookbooks repo](https://github.com/aws/opsworks-cookbooks/blob/release-chef-11.10/opsworks_nodejs/templates/default/opsworks.js.erb).

#### deploy::nodejs

This recipe (along with the related undeploy and and stop) are part of the 
[OpsWorks deploy cookbook](https://github.com/aws/opsworks-cookbooks/tree/release-chef-11.10/deploy).

The only customizations we make for this recipe are in the deploy/attributes/customize.rb file. Namely:

```
# basically for each app set the restart and stop commands to use pm2
unless node[:deploy].nil?
    node[:deploy].each do |application, deploy|
        normal[:deploy][application][:nodejs][:restart_command] = "sudo pm2 restart all"
        normal[:deploy][application][:nodejs][:stop_command] = "sudo pm2 stop all"
    end
end
```

#### pm2

Essentially this recipe just starts or restarts the node processes through pm2. However, the application.json
is configured for the box through pm2/templates/default/application.json.erb (deployed to 
/etc/pm2/conf.d/server.json). In this template, you can see
that we set some pm2 configuration options and then put all the environment variables passed into
custom JSON into the pm2 process environment variables. So, in other words, when you execute this recipe,
you can pass in environment variables which would be accessible by the node application once it starts up.

ToDo: one issue is that if we set an environment variable in custom JSON during deploy, that variable
will get blown away with a restart. Need to have the deploy set the application level environment variables.

#### nginx

**NOTE**: This is not currently being used by GetHuman. I removed it temporarily and just have
pm2 running since nginx was creating unnecessary complexity. I will add it back once I start
to work on page caching, etc.

The main goal here is to install nginx and start it up based on the custom nginx.conf file (which
comes from nginx/templates/default/nginx.conf.erb). The custom nginx.conf file contains the following:

* **logs** - Error and access logs sent to /var/log/nginx
* **gzip** - Responses gzipped
* **proxy** - All requests proxied to port 8888 for the node process

In the future we may add page caching here and/or auto-redirects.

ToDo: need to test this out and get the following functionality working:

* Running on port 80, proxy to node process
* Page caching (follow [ngnix rules for paths](http://nginx.org/en/docs/http/ngx_http_core_module.html#location))
* Force SSL (read guide on doing [ngnix redirects](http://stackoverflow.com/questions/10294481/how-to-redirect-a-url-in-nginx))

## Environment Variables

There are two primary places where environment variables can be set. The first is in the application configuration.
The second is during a deploy or other command on an instance if custom JSON is passed in that matches this format:

```javascript
{
  "deploy": {
    "app": {
      "environment_variables": {
        "PRIVATE": "SECRETZ"
      }
    }
  }
}
```
