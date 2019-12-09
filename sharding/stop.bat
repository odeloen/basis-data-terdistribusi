@echo off
docker stop router
REM docker rm router

docker stop shard-1
REM docker rm shard-1

docker stop shard-2
REM docker rm shard-2

docker stop shard-3
REM docker rm shard-3

docker stop config-1
REM docker rm config-1

docker stop config-2
REM docker rm config-2

REM docker volume prune