# Mongo DB Sharding dengan Docker pada Windows

## Outline
1. Instalasi docker
1. Konfigurasi sharding MongoDB
2. Menghubungkan MongoDB dengan Laravel

## Instalasi docker

- Download docker desktop untuk windows pada Web Official Docker  
- Jalankan executable installer docker desktop  
- Pull MongoDB untuk docker  
    ```
    docker pull mongo:4.2
    ```

## Konfigurasi sharding MongoDB

- Membuat subnet pada docker
    ```
    docker network create --subnet=192.168.0.0/22 dbnet
    ```
- Membuat MongoDB Config Server
    ```
    docker run -d --net dbnet --ip 192.168.1.1 -p 37019:27019 --name config-1 --hostname config-1 mongo:4.2 --replSet config-conf --configsvr
    
    docker run -d --net dbnet --ip 192.168.1.2 -p 37029:27019 --name config-2 --hostname config-2 mongo:4.2 --replSet config-conf --configsvr
    
    docker exec -it config-1 mongo -port 27019 --eval "rs.initiate({ _id: 'config-conf', members: [{ _id: 0, host: '192.168.1.1:27019' }, { _id: 1, host: '192.168.1.2:27019' }]});"
    ```
- Membuat MongoDB Shard Server
    ```
    docker run -d --net dbnet --ip 192.168.2.1 -p 47018:27018 --name shard-1 --hostname shard-1 mongo:4.2 --replSet shard-1-rs --shardsvr

    docker run -d --net dbnet --ip 192.168.2.2 -p 47028:27018 --name shard-2 --hostname shard-2 mongo:4.2 --replSet shard-2-rs --shardsvr

    docker run -d --net dbnet --ip 192.168.2.3 -p 47038:27018 --name shard-3 --hostname shard-3 mongo:4.2 --replSet shard-3-rs --shardsvr
    ```
- Memasukkan Shard Server kedalam Replica set yang terpisah
    ```
    docker exec -it shard-1 mongo -port 27018 --eval "rs.initiate({ _id: 'shard-1-rs', members: [{ _id: 0, host: '192.168.2.1:27018' }]})"

    docker exec -it shard-2 mongo -port 27018 --eval "rs.initiate({ _id: 'shard-2-rs', members: [{ _id: 1, host: '192.168.2.2:27018' }]})"

    docker exec -it shard-3 mongo -port 27018 --eval "rs.initiate({ _id: 'shard-3-rs', members: [{ _id: 2, host: '192.168.2.3:27018' }]})"

    ```
- Membuat MongoDB Server sebagai Router
    ```
    docker run -d --net dbnet --ip 192.168.0.2 -p 27017:27017 --name router --hostname router mongo:4.2 mongos --configdb config-conf/192.168.1.1:27019,192.168.1.2:27019 --bind_ip_all
    ```
- Memasukkan informasi Replika Set ke Router
    ```
    docker exec -it router mongo --eval "sh.addShard('shard-1-rs/192.168.2.1:27018'); sh.addShard('shard-2-rs/192.168.2.2:27018'); sh.addShard('shard-3-rs/192.168.2.3:27018');"
    ```
- Membuat database
    ```
    docker exec -it router mongo --eval "use retail-food-stores"
    ```
- Mengaktifkan sharding pada database
    ```
    docker exec -it router mongo --eval "sh.enableSharding('retail-food-stores'); db.createCollection('retail'); sh.shardCollection('retail-food-stores.retail', {'_id': 'hashed'});"
    ```
- Mengcopy data
    ```
    docker cp retail-food-stores.csv router:/retail-food-stores.csv
    ```
- Mengimport data ke database
    ```
    docker exec -it router mongoimport -d retail-food-stores -c retail --type csv --file retail-food-stores.csv --headerline
    ```

## Menghubungkan MongoDB dengan Laravel

- Menginstall ekstensi MongoDB PHP Extension    
- Menginstall Laravel Eloquent for MongoDB
    ```
    composer require jenssegers/mongodb
    ```
- Menambahkan informasi database pada env
    ```
    MONGO_DB_HOST=127.0.0.1
    MONGO_DB_PORT=27017
    MONGO_DB_DATABASE=mongocrud
    MONGO_DB_USERNAME=
    MONGO_DB_PASSWORD=
    ```
- Menambahkan informasi connection pada config/database.php
    ```    
    'connections' => [

        ...
     'mongodb' => [
            'driver'   => 'mongodb',
            'host'     => env('MONGO_DB_HOST', 'localhost'),
            'port'     => env('MONGO_DB_PORT', 27017),
            'database' => env('MONGO_DB_DATABASE'),
            'username' => env('MONGO_DB_USERNAME'),
            'password' => env('MONGO_DB_PASSWORD'),
            'options'  => []
        ],
    ]
    ```
- Menambahkan provider pada config/app.php:
    ```
    Jenssegers\Mongodb\MongodbServiceProvider::class,
    ```
- Melakukan inheritance model dengan Eloquent untuk MongoDB
    ```
    <?php

    namespace App;

    use Illuminate\Database\Eloquent\Model;
    use Jenssegers\Mongodb\Eloquent\Model as Eloquent;

    class Retail extends Eloquent
    {
        protected $connection = 'mongodb';
        protected $collection = 'retails';                
    }
    ```