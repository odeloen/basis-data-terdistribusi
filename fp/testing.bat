docker run --name pd1 --net tidbnet --ip 192.168.16.129 -p 51001:2379 -p 52001:2380 pingcap/pd:latest --name="pd1" --client-urls="http://0.0.0.0:2379" --advertise-client-urls="http://192.168.16.129:2379" --peer-urls="http://0.0.0.0:2380" --advertise-peer-urls="http://192.168.16.129:2380" --initial-cluster="pd1=http://192.168.16.129:2380,pd2=http://192.168.16.130:2380,pd3=http://192.168.16.131:2380"

docker run --name pd2 --net tidbnet --ip 192.168.16.130 -p 51002:2379 -p 52002:2380 pingcap/pd:latest --name="pd2" --client-urls="http://0.0.0.0:2379" --advertise-client-urls="http://192.168.16.130:2379" --peer-urls="http://0.0.0.0:2380" --advertise-peer-urls="http://192.168.16.130:2380" --initial-cluster="pd1=http://192.168.16.129:2380,pd2=http://192.168.16.130:2380,pd3=http://192.168.16.131:2380"

docker run --name pd3 --net tidbnet --ip 192.168.16.131 -p 51003:2379 -p 52003:2380 pingcap/pd:latest --name="pd3" --client-urls="http://0.0.0.0:2379" --advertise-client-urls="http://192.168.16.131:2379" --peer-urls="http://0.0.0.0:2380" --advertise-peer-urls="http://192.168.16.131:2380" --initial-cluster="pd1=http://192.168.16.129:2380,pd2=http://192.168.16.130:2380,pd3=http://192.168.16.131:2380"

docker run --name tikv1 --net tidbnet --ip 192.168.16.139 -p 53001:20160 pingcap/tikv:latest --addr="0.0.0.0:20160" --advertise-addr="192.168.16.139:20160" --pd="192.168.16.129:2379,192.168.16.130:2379,192.168.16.131:2379"

docker run --name tikv2 --net tidbnet --ip 192.168.16.140 -p 53002:20160 pingcap/tikv:latest --addr="0.0.0.0:20160" --advertise-addr="192.168.16.140:20160" --pd="192.168.16.129:2379,192.168.16.130:2379,192.168.16.131:2379"

docker run --name tikv3 --net tidbnet --ip 192.168.16.141 -p 53003:20160 pingcap/tikv:latest --addr="0.0.0.0:20160" --advertise-addr="192.168.16.141:20160" --pd="192.168.16.129:2379,192.168.16.130:2379,192.168.16.131:2379"

docker run --name tidb --net tidbnet --ip 192.168.16.149 -p 4000:4000 -p 10080:10080 pingcap/tidb:latest --store=tikv --path="192.168.16.129:2379,192.168.16.130:2379,192.168.16.131:2379"

docker run --name grafana --net tidbnet --ip 192.168.16.160 -p 3000:3000 grafana/grafana --config="/conf/grafana.ini"

prometheus --config.file="etc/prometheus/prometheus.yml" --web.listen-address=":9090" --web.external-url="http://192.168.16.159:9090/" --web.enable-admin-api --log.level="info" --storage.tsdb.path="./data.metrics" --storage.tsdb.retention="15d"