#!/bin/bash

workdir="/media/ssd2/kafka/kafka"

if [[ "$1" == "start" ]]; then
    echo "Starting Kafka cluster..."
    CLUSTER_UUID=$(kafka-storage.sh random-uuid)
    echo "Cluster UUID: $CLUSTER_UUID"
    for prop in broker-01 broker-02 broker-03 controller_04 controller_05 controller_06; do
        kafka-storage.sh format -t $CLUSTER_UUID  --ignore-formatted -c  $workdir/config/${prop}.properties
        kafka-server-start.sh -daemon $workdir/config/${prop}.properties

       #kafka-storage.sh format -t K02MZrT7RZScJ2SqK8uncg --ignore-formatted -c  $workdir/config/broker-01.properties
       #kafka-server-start.sh  $workdir/config/broker-01.properties
       echo "Started ${prop}"
    done
    echo "Kafka cluster started with UUID: $CLUSTER_UUID"
elif [[ "$1" == "stop" ]]; then
    echo "Stopping Kafka cluster..."
    for prop in broker-01 broker-02 broker-03 controller_04 controller_05 controller_06; do
        kafka-server-stop.sh $workdir/config/${prop}.properties
        echo "Stopped ${prop}"
    done
    echo "Kafka cluster stopped."
elif [[ "$1" == "clean" ]]; then
    echo "Deleting temp files..."
    find /home/prem/workspace/ -type f -name '*.tmp' -exec rm -f {} +
    echo "Deleting all files inside /tmp/kraft-* directories..."
    find /tmp/ -type d -name 'kraft-*' -exec sh -c 'rm -rf "$0"/*' {} \;
    echo "Temp files and kraft-* directory contents deleted."
else
    echo "Usage: $0 {start|stop}"
    exit 1
fi


## 
## ps -ef | grep 'kafka.Kafka' | grep -v grep | awk '{print $2}' | sudo xargs kill -9

## ps -ef | grep -E "redis-server.*cluster" | grep -v grep | awk '{print $2}' | sudo xargs kill -9