#!/bin/bash

ports=(7000 7001 7002 7003 7004 7005)
host=0.0.0.0
dir="/media/ssd2/redis"

usage() {
    echo "Usage: $0 [cluster start|server start|stop]"
    exit 1
}

if [ $# -lt 1 ]; then
    usage
fi

case "$1" in
    "server start")
        for port in "${ports[@]}"; do
            (
                cd "$dir/$port" || exit
                nohup redis-server redis.conf > redis.log 2>&1 &
            )
        done
        ;;
    "cluster start")
        export REDISCLI_AUTH="prem_cluster:Gan83"
        for port in "${ports[@]}"; do
               (
                cd "$dir/$port" || exit
                nohup redis-server redis.conf > redis.log 2>&1 &
              
            )
        done
        sleep 3
        nodes=()
        for port in "${ports[@]}"; do
            nodes+=("$host:$port")
        done
        redis-cli --cluster create "${nodes[@]}" --cluster-replicas 1  --user prem_cluster --pass Gan83
        ;;
    "stop")
        export REDISCLI_AUTH="prem_cluster:Gan83"
        for port in "${ports[@]}"; do
           redis-cli -h $host -p $port -u prem_cluster -a GanSHUTDOWN SAVE || echo "Redis on port $port is not running."
        done
        for port in "${ports[@]}"; do
            find "$dir/$port" -mindepth 1 ! -name "redis.conf" -exec rm -rf {} +
        done
        ;;
        "clean")
        for port in "${ports[@]}"; do
            rm -rf "$dir/$port"
        done
        ;;
            "clean_log")
        for port in "${ports[@]}"; do
            rm -rf "$dir/$port"
        done
        ;;
    *)
        usage
        ;;
esac