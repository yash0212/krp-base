#!/bin/bash

# Set default values if environment variables are not provided
DB_NAME=${DB_NAME:-krp}
DB_PASSWORD=${DB_PASSWORD:-fP3DLLuFwDVPAZ51}
ADMIN_PASSWORD=${ADMIN_PASSWORD:-admin}
SITE_CONFIG_PATH=${SITE_CONFIG_PATH:-/home/frappe/frappe-bench/sites/frontend/site_config.json}
DB_TYPE=${DB_TYPE:-mariadb}

rm -rf sites/frontend

# bench new-site --no-mariadb-socket --db-host $DB_HOST --db-name $DB_NAME --db-password $DB_PASSWORD --db-root-username $DB_ROOT_USERNAME --db-root-password $DB_ROOT_PASSWORD --admin-password $ADMIN_PASSWORD --install-app krp frontend
bench new-site --db-type $DB_TYPE --db-host $DB_HOST --db-name $DB_NAME --db-password $DB_PASSWORD --db-root-username $DB_ROOT_USERNAME --db-root-password $DB_ROOT_PASSWORD --admin-password $ADMIN_PASSWORD --install-app krp frontend

cat /home/frappe/frappe-bench/sites/frontend/site_config.json