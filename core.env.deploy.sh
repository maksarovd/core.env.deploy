#!/bin/bash

if [ -z "$1" ]; then
    echo "Ошибка: Укажитее имя проекта"
    exit 1
fi


#locate all files
CEDIR=$(pwd)

cd ../
PROJECTS_DIR=$(pwd)


#locate all services
SERVICES=(
"php"
"nginx"
"mysql"
#"mariadb"
#"postgres"
#"redis"
#"mongodb"
"vue"
)

#dynamic add volume if service selected
#then render volumes
VOLUMES=(

)


echo "Deploying selected services"

#remove previous project dir context
if [ -d "$1" ]; then
    cd $1
    docker-compose stop
    docker-compose down --volumes
    rm -rf *
else
    mkdir $1
    cd $1
    rm -rf *
fi



touch docker-compose.yml
cat <<EOL > docker-compose.yml
version: '3'
services:
EOL

for service in "${SERVICES[@]}"; do

if [ $service == "mysql" ]; then
cat <<EOL >> docker-compose.yml

  mysql:
    image: mysql:5.7.37
    restart: "no"
    hostname: mysql
    volumes:
      - './mysql/my.cnf:/etc/mysql/my.cnf'
      - './mysql:/home'
    ports:
      - "3306:3306"
    environment:
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_ROOT_HOST= "0.0.0.0"
      - MYSQL_DATABASE=database
      - MYSQL_USER=maksarovd
      - MYSQL_PASSWORD=1
EOL


if [ -d "mysql" ]; then
    cd mysql
else
    mkdir mysql
    cd mysql
fi

cp "$CEDIR/mysql/my.cnf" "$PROJECTS_DIR/$1/mysql/my.cnf"

cd ../

elif [ $service == "nginx" ];then
cat <<EOL >> docker-compose.yml

  nginx:
    image: nginx:latest
    volumes:
      - './app:/var/www/html'
      - './nginx/default.conf:/etc/nginx/conf.d/default.conf'
      - './nginx/nginx.conf:/etc/nginx/nginx.conf'
    ports:
      - 80:80
      - 443:443
EOL

if [ -d "app" ]; then
    cd app
else
    mkdir app
    cd app
fi

touch index.php
cat <<EOL > index.php
<?php phpinfo();
EOL

cd ../


if [ -d "nginx" ]; then
    cd nginx
else
    mkdir nginx
    cd nginx
fi

cp "$CEDIR/nginx/default.conf" "$PROJECTS_DIR/$1/nginx/default.conf"
cp "$CEDIR/nginx/nginx.conf" "$PROJECTS_DIR/$1/nginx/nginx.conf"

cd ../

elif [ $service == "php" ];then

cat <<EOL >> docker-compose.yml

  php:
    build:
      context: php
      dockerfile: Dockerfile
      args:
        - VERSION_PHP=php:8.2-fpm
    volumes:
      - './app:/var/www/html'
      - './php/xdebug.ini:/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini'
    expose:
      - 9000
EOL


if [ -d "app" ]; then
    cd app
else
    mkdir app
    cd app
fi

touch index.php
cat <<EOL > index.php
<?php phpinfo();
EOL

cd ../


if [ -d "php" ]; then
    cd php
else
    mkdir php
    cd php
fi

cp "$CEDIR/php/xdebug.ini" "$PROJECTS_DIR/$1/php/xdebug.ini"
cp "$CEDIR/php/Dockerfile" "$PROJECTS_DIR/$1/php/Dockerfile"

cd ../


elif [ $service == "redis" ]; then
cat <<EOL >> docker-compose.yml

  redis:
    image: redis:6.2.6
    hostname: redis
    volumes:
      - './app:/var/www/html'
    ports:
      - 6379:6379
EOL

if [ -d "app" ]; then
    cd app
else
    mkdir app
    cd app
fi

cd ../

elif [ $service == "postgres" ];then
cat <<EOL >> docker-compose.yml

  #psql -U maksarovd -d database -h localhost -W
  #sudo docker-compose down --volumes
  postgres:
    image: postgres:latest
    ports:
      - 5432:5432
    volumes:
      - postgres:/var/lib/postgresql/data
    environment:
      - POSTGRES_PASSWORD=1
      - POSTGRES_USER=maksarovd
      - POSTGRES_DB=database
EOL

VOLUMES+=("postgres")

elif [ $service == "mongodb" ];then
cat <<EOL >> docker-compose.yml

  #mongosh --host localhost --port 27017
  #create own users @see mongodb/init-mongo.js
  mongodb:
    image: mongo:latest
    restart: always
    ports:
      - 27017:27017
    volumes:
      - mongodb:/data/db
      - ./mongodb/init-mongo.js:/docker-entrypoint-initdb.d/init-mongo.js:ro
EOL

if [ -d "mongodb" ]; then
    cd mongodb
else
    mkdir mongodb
    cd mongodb
fi

cd ../

cp "$CEDIR/mongodb/init-mongo.js" "$PROJECTS_DIR/$1/mongodb/init-mongo.js"

VOLUMES+=("mongodb")
elif [ $service == "mariadb" ];then
cat <<EOL >> docker-compose.yml

  mariadb:
    image: mariadb:latest
    ports:
      - "3307:3306"
    environment:
      MARIADB_ROOT_PASSWORD: root
      MARIADB_DATABASE: database
      MARIADB_USER: maksarovd
      MARIADB_PASSWORD: 1
    volumes:
      - mariadb:/var/lib/mysql
      - ./mariadb/init.sql:/docker-entrypoint-initdb.d/init.sql:ro
EOL
if [ -d "mariadb" ]; then
    cd mariadb
else
    mkdir mariadb
    cd mariadb
fi
cd ../
cp "$CEDIR/mariadb/init.sql" "$PROJECTS_DIR/$1/mariadb/init.sql"
VOLUMES+=("mariadb")

elif [ $service == "vue" ];then
cat <<EOL >> docker-compose.yml

  # vue create .
  # npm run serve
  vue:
    build:
      context: vue
      dockerfile: Dockerfile
    ports:
      - "8080:8080"
    volumes:
      - ./vue:/app
EOL
if [ -d "vue" ]; then
    cd vue
else
    mkdir vue
    cd vue
fi
cd ../

cp "$CEDIR/vue/Dockerfile" "$PROJECTS_DIR/$1/vue/Dockerfile"

fi


done

echo "Adding volumes stage"

if [ ${VOLUMES[@]} -gt 0 ]; then
cat <<EOL >> docker-compose.yml

volumes:
EOL
fi

for volume in "${VOLUMES[@]}"; do

  if [ $volume == "postgres" ]; then
cat <<EOL >> docker-compose.yml
  $volume:
EOL
  elif [ $volume == "mongodb" ]; then
cat <<EOL >> docker-compose.yml
  $volume:
EOL
  elif [ $volume == "mariadb" ]; then
cat <<EOL >> docker-compose.yml
  $volume:
    driver: local
EOL
  fi

done

docker-compose up -d --build