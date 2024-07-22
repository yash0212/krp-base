## Locally Create new site with neon postgres

bench new-site library.localhost --db-type postgres --db-name frappe --db-root-username yash

## Install command python package in bench

    bench pip install <package_name>

## Command to install krp app on site
    bench --site kalvium.localhost install-app krp

## Notes
- DocType has to have prefix. Reason - Frappe doesn't handle DocType name collision from multiple apps
- Module may or may not have a prefix but good to have to identify easily in DocType authoring/configuration
- We cannot have db name and db password in env for some reason

## Kubernetes local setup (ignore)

### 1. Install KinD
1. curl -Lo ./kind https://github.com/kubernetes-sigs/kind/releases/download/v0.23.0/kind-linux-amd64
2. chmod +x ./kind
3. sudo mv ./kind /usr/local/bin/kind

### 2. Create KinD cluster
    kind create cluster --name kalvium

### 3. Add Ingress container
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.1/deploy/static/provider/cloud/deploy.yaml

## Load apps.json to APPS_JSON_BASE64 env
    export APPS_JSON_BASE64=$(echo $(cat apps.json) | base64 -w 0)

## Build command
    docker build -t krp \
        --build-arg=APPS_JSON_BASE64=$APPS_JSON_BASE64 \
        --build-arg=FRAPPE_SITE_NAME_HEADER="krp.kalvium" \
        .

## Start backend container

### Without redis config in ENV
    docker run -d --name backend -p 8000:8000 krp
### With config in ENV

#### Mariadb full config
    docker run -d --name backend -p 8000:8000 \
        -e FRAPPE_REDIS_QUEUE='redis://172.17.0.1:6666' \
        -e FRAPPE_REDIS_CACHE='redis://172.17.0.1:7777' \
        -e FRAPPE_DB_TYPE='mariadb' \
        -e FRAPPE_DB_HOST='172.17.0.4' \
        -e FRAPPE_DB_PORT='3306' \
        -e DB_NAME='krp' \
        -e DB_PASSWORD='yd8MGNQ7FxSkfyXe' \
        krp

#### Postgres full config
    docker run -d --name backend -p 8000:8000 \
        -e FRAPPE_REDIS_QUEUE='redis://172.17.0.1:6666' \
        -e FRAPPE_REDIS_CACHE='redis://172.17.0.1:7777' \
        -e FRAPPE_DB_TYPE='postgres' \
        -e FRAPPE_DB_HOST='172.17.0.1' \
        -e FRAPPE_DB_PORT='5432' \
        -e DB_NAME='krp' \
        -e DB_PASSWORD='BE3OneacBXLNeban' \
        krp

#### Postgres minimal config
    docker run -d --name backend -p 8000:8000 \
        -e FRAPPE_REDIS_CACHE='redis://172.17.0.1:7777' \
        -e FRAPPE_REDIS_QUEUE='redis://172.17.0.1:6666' \
        -e FRAPPE_DB_TYPE='postgres' \
        -e FRAPPE_DB_HOST='172.17.0.7' \
        -e FRAPPE_DB_PORT='5432' \
        -e DB_NAME='krp' \
        krp

## Command to get IP of container
    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' backend
    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' maridb
    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' frontend
    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' redis-cache
    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' redis-queue

## Command to run frontend container(locally)
    docker run -d --name frontend -p 8080:8080 -e BACKEND='172.17.0.3:8000' -e FRAPPE_SITE_NAME_HEADER='krp.kalvium' --entrypoint nginx-entrypoint.sh krp

## Requirement
2 bench having single site each from same bench image but different domain name

## New Site command MariaDB
    bench new-site --db-host 172.17.0.2 --db-name krp --db-root-username root --db-root-password admin --admin-password admin krp.kalvium

## New Site command PostGres
    bench new-site --db-host 172.17.0.1 --db-name krp --db-root-username postgres --db-root-password mysecretpassword --db-type postgres --admin-password admin krp.kalvium

## MariaDB krp.kalvium
    {
        "db_host": "172.17.0.2",
        "db_name": "krp",
        "db_password": "yd8MGNQ7FxSkfyXe",
        "db_type": "mariadb"
    }
## Redis start command
    docker run -d --name redis-queue -p 6666:6379 redis:6.2-alpine
    docker run -d --name redis-cache -p 7777:6379 redis:6.2-alpine

## Misc
https://github.com/frappe/frappe_docker/blob/main/docs/troubleshoot.md
https://discuss.frappe.io/t/pymysql-err-operationalerror-1045-access-denied-for-user-docker-mac-local-installation/85525
https://discuss.frappe.io/t/pymysql-err-operationalerror-1045-access-denied-for-user-root-localhost-using-password-yes/82542
https://discuss.frappe.io/t/pymysql-err-operationalerror-1045-access-denied-for-user-root-localhost-using-password-yes-mac/55080
https://discuss.frappe.io/t/bench-site-erpnext-site-force-reinstall-generate-this-error-pymysql-err-operationalerror-1045-access-denied-for-user-my-user-localhost-using-password-yes/66542