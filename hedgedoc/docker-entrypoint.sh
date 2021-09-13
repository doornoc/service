#!/bin/bash

# set -euo pipefail

if [[ "$#" -gt 0 ]]; then
    exec "$@"
    exit $?
fi

# run DB migrate
NEED_MIGRATE=${CMD_AUTO_MIGRATE:=true}

if [[ "$NEED_MIGRATE" = "true" ]] && [[ -f .sequelizerc ]] ; then
    npx sequelize db:migrate
fi

# start application
cd /opt/hedgedoc/
node app.js
