# GetHuman AWS OpsWorks Cookbooks

A collection of cookbooks used by GetHuman for some deployments. We tried to set this up in a generic
way so it actually could be used by anyone. At a high level, these cookbooks work on top of the
default AWS OpsWorks cookbooks. Anything GetHuman-specific has been abstracted out into environment
variables that can be set at the App level in an OpsWorks stack. The information in this README
includes:

* Dev Setup - Setup for dev that want to modify cookbooks
* Recipes - The unique recipes for this repo
* ToDos

## Dev Setup

Do these first

1. Install ruby
1. gem install foodcritic
1. brew install Caskroom/cask/chefdk
  * Note: this will install [Berkshelf](http://berkshelf.com/)

Misc notes

* Only one app that needs to be called 'App' when created, but then can be changed
* Put env variables at app level and then also environment

## Recipes

You will need to use a custom layer within OpsWorks. Then include these recipes:

* **setup** - logs::config, logs::install, nodejs-wrapper-opsworks, nodejs-wrapper-opsworks::create-symlink
* **configure** - opsworks_nodejs::configure
* **deploy** - deploy::nodejs, pm2
* **undeploy** - deploy::nodejs-undeploy
* **shutdown** - deploy::nodejs-stop

#### nodejs-wrapper-opsworks

There are two changes that needed to be made from the [original repo](https://github.com/zupper/nodejs-wrapper-opsworks).
First, in attributes/default.rb, we needed to set the following:

```
default['nodejs']['version'] = '0.12.2'
default["nodebin"]["location"] = '/usr/bin/node'
default["nodebin"]["opsworks_location"] = '/usr/local/bin/node'
```

Then in recipes/default.rb we changed the following:

```
# need to install from binary or it won't work for some reason
# include_recipe 'nodejs'
include_recipe 'nodejs::nodejs_from_binary'
```

This recipe wraps the nodejs cookbook and basically installs our desired version of Node.js (or io.js) on
OpsWorks. The create-symlink recipe is called right after the node install in order to create a symlink
from the place where OpsWorks expects node to be to the installed version from the nodejs recipe.

#### logs

We are using a [shared logging cookbook](https://github.com/awslabs/opsworks-cloudwatch-logs-cookbooks) to
set up a CloudWatch agent on the servers in order to capture logs. 
[This article](http://blogs.aws.amazon.com/application-management/post/TxTX72HFKVS9W9/Using-Amazon-CloudWatch-Logs-with-AWS-OpsWorks)
explains what is going on. 

Note that this is not working yet. Need work here to figure it out.









## refactor below

#### ssl

* lifecycle stage: setup
* recipes: gethuman::ssl

The chef recipe does (?), but most of the work is in the 
[nginx conf](https://github.com/gethuman/cookbooks/blob/master/gethuman/templates/default/nginx.conf.erb)
starting at line 89. This follows the 
[guide on how to do nginx redirects](http://stackoverflow.com/questions/10294481/how-to-redirect-a-url-in-nginx).

#### caching

* lifecycle stage: setup
* recipes: gethuman::caching

The chef recipe does (?), but most of the work is in the 
[nginx conf](https://github.com/gethuman/cookbooks/blob/master/gethuman/templates/default/nginx.conf.erb)
starting at line 113. The key here is to set the cached_routes environment variable with the
routes that need to be cached. The routes follow the [ngnix rules for paths](http://nginx.org/en/docs/http/ngx_http_core_module.html#location).

### nodejs

* lifecycle stage: none (run ad hoc)
* recipes: gethuman::nodejs_start gethuman::nodejs_stop
* Note that this requires 'Manage Berkshelf' to be 'Yes' (Stack -> Stack Settings -> Edit).
* Also note that this recipe will set [NODE_ENV=production](http://stackoverflow.com/questions/22197655/customize-node-js-start-command-with-aws-opsworks)
* Read the [PM2 manual](https://github.com/Unitech/PM2/blob/master/ADVANCED_README.md) as a reference

The idea here is to run (?) when we want to restart node on an instance.

#### environment

* lifecycle stage: setup
* recipes: gethuman::environment

The purpose of this recipe is to update the environment variables with a new set. This
recipe leverages [AWS Attribute Precedence](http://docs.aws.amazon.com/opsworks/latest/userguide/workingcookbook-attributes-precedence.html)
(listed from lowest precedence to highest):

__[Custom cookbook default attributes](https://github.com/gethuman/cookbooks/blob/master/gethuman/attributes/custom.rb)__

```
default['environment_variables']['ENVIRONMENT_1'] = 'SECRET_1'
default['environment_variables']['ENVIRONMENT_2'] = 'SECRET_2'
```

__Stack level environment variables__

```javascript
{
  // All stack environment variables to be copied over to the instance:
  "environment_variables": {
    "GETHUMAN_STACK": "SECRET"
  },

  // Specific Appl Level environment variables:
  "deploy": {
    "app_name": {
      "environment_variables": {
        "PRIVATE": "SECRETZ"
      }
    }
  }
}
```

__App Level Opsworks Custom JSON__

```javascript
{
  // Specific Appl Level environment variables:
  "deploy": {
    "app_name": {
      "environment_variables": {
        "GETHUMAN_APP": "SECRET",
        "GETHUMAN_STACK": "OVERRIDE SECRET"
      }
    }
  }
}
```

__App Level Opsworks Console (with protected values)__

![](http://new.tinygrab.com/d53b50c20608657f4f3d67ffdd7f960f68ee2fe63d.png)


__Deploy Level__

Environment variables can be set on a "per instance deploy".
Click "Advanced" to show custom JSON settings.

This setting is located within AWS OpsWorks console under Deploy App.
The variables set here take the highest precedence of all settings.

![](http://new.tinygrab.com/d53b50c2067987fbdceb6d30b93096ecee449c5d9c.png)

```javascript
{
  // All instance environment variables:
  "environment_variables": {
    "PRIVATE": "SECRETZ"
  },

  // Specific instance environment variables:
  "deploy": {
    "app_name": {
      "environment_variables": {
        "PRIVATE": "SECRETZ"
      }
    }
  }
}
```

## ToDos

* Rollback - Manually through (Deployments -> Deploy -> Rollback), but figure out command line for this.
* NVM - Only options are [custom ALI](http://github.com/zupper/nodejs-wrapper-psworks), [custom ubuntu install](http://serverfault.com/questions/674089/how-can-i-get-node-js-0-12-0-running-on-aws-opsworks) or custom OpsWorks layer
* Fork - We should fork atop opsworks-cookbooks so adding updates is easier. Note that include_attribute is deprectated and [we use it](https://github.com/gethuman/cookbooks/blob/master/gethuman/attributes/nginx.rb).
