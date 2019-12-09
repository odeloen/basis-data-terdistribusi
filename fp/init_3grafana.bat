docker run -d ^
    --name grafana ^
    --net tidbnet ^
    --ip 192.168.16.160 ^
    -p 3000:3000 ^
    -v "E:/10-College/semester-7/BDT/basis-data-terdistribusi/fp/grafana/grafana.ini:/conf/grafana.ini" ^
    grafana/grafana ^
    --config="/conf/grafana.ini"

timeout /t 5 /nobreak > nul

REM docker cp ./grafana/grafana.ini grafana:/grafana.ini
REM docker exec -d -it grafana grafana-server --config="/grafana.ini"