REM Create network
docker network create --subnet=192.168.16.0/24 redisnet

REM Initiate redis node
docker run -d --net redisnet --ip 192.168.16.129 -p 6381:6379 --name node-1 --hostname node-1 -e REDIS_REPLICATION_MODE=master -e ALLOW_EMPTY_PASSWORD=yes bitnami/redis
docker run -d --net redisnet --ip 192.168.16.130 -p 6382:6379 --name node-2 --hostname node-2 -e REDIS_REPLICATION_MODE=slave -e REDIS_MASTER_HOST=192.168.16.129 -e REDIS_MASTER_PORT_NUMBER=6379 -e ALLOW_EMPTY_PASSWORD=yes bitnami/redis
docker run -d --net redisnet --ip 192.168.16.131 -p 6383:6379 --name node-3 --hostname node-3 -e REDIS_REPLICATION_MODE=slave -e REDIS_MASTER_HOST=192.168.16.129 -e REDIS_MASTER_PORT_NUMBER=6379 -e ALLOW_EMPTY_PASSWORD=yes bitnami/redis

REM Initiate redis sentinel
docker run -d --net redisnet --ip 192.168.16.132 -p 26381:26379 --name sentinel-1 --hostname sentinel-1 -e REDIS_MASTER_HOST=192.168.16.129 -e REDIS_MASTER_PORT_NUMBER=6379  -e REDIS_SENTINEL_QUORUM=2 bitnami/redis-sentinel
docker run -d --net redisnet --ip 192.168.16.133 -p 26382:26379 --name sentinel-2 --hostname sentinel-2 -e REDIS_MASTER_HOST=192.168.16.129 -e REDIS_MASTER_PORT_NUMBER=6379  -e REDIS_SENTINEL_QUORUM=2 bitnami/redis-sentinel
docker run -d --net redisnet --ip 192.168.16.134 -p 26383:26379 --name sentinel-3 --hostname sentinel-3 -e REDIS_MASTER_HOST=192.168.16.129 -e REDIS_MASTER_PORT_NUMBER=6379  -e REDIS_SENTINEL_QUORUM=2 bitnami/redis-sentinel

REM Initiate mysql node
docker run -d --net redisnet --ip 192.168.16.135 -p 33060:3306 --name mysql --hostname mysql -e MYSQL_ROOT_PASSWORD=root mysql:5.7
docker exec -d -it mysql mysql -uroot -proot -e "create database redistest;"
docker exec -d -it mysql mysql -uroot -proot -e "create database noredis;"

docker run -d --net redisnet --ip 192.168.16.136 -p 50001:80 --name wordpress --hostname wordpress -e WORDPRESS_DB_HOST=192.168.16.135 -e WORDPRESS_DB_USER=root -e WORDPRESS_DB_PASSWORD=root -e WORDPRESS_DB_NAME=redistest -e WORDPRESS_CONFIG_EXTRA="define('WP_REDIS_CLIENT', 'predis'); define('WP_REDIS_SENTINEL', 'mymaster');define('WP_REDIS_SERVERS',['tcp://192.168.16.132:26379?alias=sentinel-1','tcp://192.168.16.133:26379?alias=sentinel-2','tcp://192.168.16.134:26379?alias=sentinel-3']);define('WP_CACHE',true);" wordpress:5.3.0-apache

docker run -d --net redisnet --ip 192.168.16.137 -p 40001:80 --name wordpress-nr --hostname wordpress -e WORDPRESS_DB_HOST=192.168.16.135 -e WORDPRESS_DB_USER=root -e WORDPRESS_DB_PASSWORD=root -e WORDPRESS_DB_NAME=noredis wordpress:5.3.0-apache