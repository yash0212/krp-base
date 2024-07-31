#!/bin/bash

# Set default values if environment variables are not provided
DB_NAME=${DB_NAME:-krp}
DB_PASSWORD=${DB_PASSWORD:-fP3DLLuFwDVPAZ51}
ADMIN_PASSWORD=${ADMIN_PASSWORD:-admin}
SITE_CONFIG_PATH=${SITE_CONFIG_PATH:-/home/frappe/frappe-bench/sites/frontend/site_config.json}
ENCRYPTION_KEY=${ENCRYPTION_KEY:-abcd1234}

# Check if site_config.json exists
if [ -f "$SITE_CONFIG_PATH" ]; then
  # Add the required configurations from environment variables
  jq --arg db_name "$DB_NAME" \
     --arg db_password "$DB_PASSWORD" \
     --arg admin_password "$ADMIN_PASSWORD" \
     --arg encryption_key "$ENCRYPTION_KEY" \
     '. + {
       "db_name": $db_name,
       "db_password": $db_password,
       "admin_password": $admin_password,
       "encryption_key": $encryption_key
     }' "$SITE_CONFIG_PATH" > "${SITE_CONFIG_PATH}.tmp" && mv "${SITE_CONFIG_PATH}.tmp" "$SITE_CONFIG_PATH"
else
  echo "site_config.json not found at $SITE_CONFIG_PATH"
  exit 1
fi

ls -1 apps > sites/apps.txt

# Install all apps
bench install-app $(ls -1 apps)

# Run migration(MIGHT not be required as installation will do the job already)
bench --site frontend migrate --skip-search-index
