#!/usr/bin/env bash

SERVER_ID=$1
SERVER_NAME=$2
USERNAME=$(id -u -n)
GROUPNAME=$(id -g -n)
CLUSTER_DIR=/opt/cluster/
HADOOP_HOME=/opt/cluster/hadoop
KAFKA_HOME=/opt/cluster/kafka
REMOTE_DIR=/opt/remote
KAFKA_CONF=${KAFKA_HOME}/config/server.properties
ZK_SERVERS=`cat ${REMOTE_DIR}/servers/zookeepers.lst`

cd ${CLUSTER_DIR};
if [[ ! -d ${KAFKA_HOME} ]]; then
    tar zxvf ${REMOTE_DIR}/packages/kafka.tgz -C ${CLUSTER_DIR}  > /dev/null
    mv ${CLUSTER_DIR}/kafka_2.11-1.1.0 ${KAFKA_HOME}
fi;

if [[ ! -d ${KAFKA_HOME}/log ]]; then
    mkdir -p ${KAFKA_HOME}/log
fi

ZK_SERVERS_CONFIG=""

for ZK_SERVER in ${ZK_SERVERS}
do
    echo ${ZK_SERVER}
    ZK_SERVERS_CONFIG="${ZK_SERVERS_CONFIG}${ZK_SERVER}:2181,"
done

echo ${ZK_SERVERS_CONFIG}

sed -i "s#/tmp/kafka-logs#${KAFKA_HOME}/log#g" ${KAFKA_CONF}
sed -i "s#zookeeper.connect=localhost:2181#zookeeper.connect=${ZK_SERVERS_CONFIG}#g" ${KAFKA_CONF}
sed -i "s#broker.id=0#broker.id=${SERVER_ID}#g" ${KAFKA_CONF}

#echo "listeners=PLAINTEXT://${SERVER_NAME}:9092" >> ${KAFKA_CONF}

ListenersLine="listeners=PLAINTEXT://${SERVER_NAME}:9092"
echo ${ListenersLine}
if [[ `grep -c "${ListenersLine}" ${KAFKA_CONF}` -eq '0' ]]; then
    printf "\n${ListenersLine}\n" >> ${KAFKA_CONF};
fi

if [[ ! -d ${KAFKA_HOME}/tmp ]]; then
    mkdir ${KAFKA_HOME}/tmp
fi
