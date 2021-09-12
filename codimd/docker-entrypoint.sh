#!/bin/sh

#dockerize -wait tcp://database:3306 -timeout 30s

#node_modules/.bin/sequelize db:migrate
#exec "$@"

set -euo pipefail

if [[ "$#" -gt 0 ]]; then
    exec "$@"
    exit $?
fi

# check database and redis is ready
#pcheck -env CMD_DB_URL

# run DB migrate
NEED_MIGRATE=${CMD_AUTO_MIGRATE:=true}

if [[ "$NEED_MIGRATE" = "true" ]] && [[ -f .sequelizerc ]] ; then
    npx sequelize db:migrate
fi

# start application
node app.js
