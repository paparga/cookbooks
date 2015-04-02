name        "opsworks_nodejs"
description 'Installs and configures a Node.js application server & UPDATES ENVIRONMENT VARIABLES'
maintainer  "Get Human"
license     "Apache 2.0"
version     "1.0.0"

depends 'gethuman'

recipe "gethuman::log", "Moves logs to CloudWatch"
recipe "gethuman::nodejs", "Starts NodeJS process using pm2"
recipe "gethuman::environment", "Set custom environment variaables"
