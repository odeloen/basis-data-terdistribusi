docker cp ./prometheus/node_exporter-0.18.1.linux-amd64/node_exporter pd1:/
docker cp ./prometheus/node_exporter-0.18.1.linux-amd64/node_exporter pd2:/
docker cp ./prometheus/node_exporter-0.18.1.linux-amd64/node_exporter pd3:/
docker cp ./prometheus/node_exporter-0.18.1.linux-amd64/node_exporter tikv1:/
docker cp ./prometheus/node_exporter-0.18.1.linux-amd64/node_exporter tikv2:/
docker cp ./prometheus/node_exporter-0.18.1.linux-amd64/node_exporter tikv3:/
docker cp ./prometheus/node_exporter-0.18.1.linux-amd64/node_exporter tidb:/

docker exec -d -it pd1 ./node_exporter
docker exec -d -it pd2 ./node_exporter
docker exec -d -it pd3 ./node_exporter
docker exec -d -it tikv1 ./node_exporter
docker exec -d -it tikv2 ./node_exporter
docker exec -d -it tikv3 ./node_exporter
docker exec -d -it tidb ./node_exporter

docker run -d ^
    --name promserver ^
    --net tidbnet ^
    --ip 192.168.16.159 ^
    -p 9090:9090 ^
    -v "E:/10-College/semester-7/BDT/basis-data-terdistribusi/fp/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml" ^
    prom/prometheus ^
    --config.file=/etc/prometheus/prometheus.yml

