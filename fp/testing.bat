docker run -d --name pd1 ^
  --net tidbnet ^
  --ip 192.168.16.129 ^
  -p 51001:2379 ^
  -p 52001:2380 ^
  pingcap/pd:latest ^
  --name="pd1" ^
  --client-urls="http://0.0.0.0:2379" ^
  --advertise-client-urls="http://192.168.16.129:2379" ^
  --peer-urls="http://0.0.0.0:2380" ^
  --advertise-peer-urls="http://192.168.16.129:2380" ^
  --initial-cluster="pd1=http://192.168.16.129:2380"

docker run -d --name tikv1 ^
  --net tidbnet ^
  --ip 192.168.16.139 ^
  -p 53001:20160 ^
  pingcap/tikv:latest ^
  --addr="0.0.0.0:20160" ^
  --advertise-addr="192.168.16.139:20160" ^
  --pd="192.168.16.129:2379"

docker run -d --name tikv2 ^
  --net tidbnet ^
  --ip 192.168.16.140 ^
  -p 53002:20160 ^
  pingcap/tikv:latest ^
  --addr="0.0.0.0:20160" ^
  --advertise-addr="192.168.16.140:20160" ^
  --pd="192.168.16.129:2379"

docker run -d --name tikv3 ^
  --net tidbnet ^
  --ip 192.168.16.141 ^
  -p 53003:20160 ^
  pingcap/tikv:latest ^
  --addr="0.0.0.0:20160" ^
  --advertise-addr="192.168.16.141:20160" ^
  --pd="192.168.16.129:2379"

docker run -d --name tidb ^
  --net tidbnet ^
  --ip 192.168.16.149 ^
  -p 4000:4000 ^
  -p 10080:10080 ^
  pingcap/tidb:latest ^
  --store=tikv ^
  --path="192.168.16.129:2379"
