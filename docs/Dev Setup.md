# How to setup for local development

## Prerequisites
1. Docker

## Steps
1. Setup Mariadb
2. Run One-time setup - creates new site on bench - Run `bench reinstall --yes --db-root-username root --db-root-password admin --admin-password admin`
3.





Problem statement
We don't want to attach volumes for sites and assets in the bench as it allows the possibility of manual file change and irregularities between deployment environments and hence we added it to the codebase. We build the assets in the build stage in Dockerfile. The problem is db initialization in initial bench setup in different deployment environments, as we don't run `bench new-site` command and bench migrate fails with `pymysql.err.ProgrammingError: (1146, "Table 'krp.tabDefaultValue' doesn't exist")` error, how can we setup the deployment to work in multiple environments. Also we'd like to know how can we do app(already added) development with the existing setup as the build stage removes .git folder.

https://github.com/yash0212/krp-base is the codebase we have so far

Mariadb Server version: 10.11.8-MariaDB-ubu2204 v10.11.8-MariaDB-ubu2204



## Try 2
run first-run.sh to create new site and setup db
consecutive runs will use entrypoint.sh which will have app installed and hopefully on runtime, it automatically migrates the app doctype