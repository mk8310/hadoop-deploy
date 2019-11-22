#!/usr/bin/env bash

SERVER_ID=$1
SERVER_NAME=$2
USERNAME=$(id -u -n)
GROUPNAME=$(id -g -n)
CLUSTER_DIR=/opt/cluster/
HADOOP_HOME=/opt/cluster/hadoop
ATLAS_HOME=/opt/cluster/atlas
REMOTE_DIR=/opt/remote
ATLAS_CONF=${ATLAS_HOME}/config/server.properties
ZK_SERVERS=`cat ${REMOTE_DIR}/servers/zookeepers.lst`

cd ${CLUSTER_DIR};
if [[ ! -d ${ATLAS_HOME} ]]; then
    tar zxvf ${REMOTE_DIR}/packages/atlas/atlas.tar.gz -C ${CLUSTER_DIR}  > /dev/null
    mv ${CLUSTER_DIR}/apache-atlas-1.1.0 ${ATLAS_HOME}
fi;

ZK_SERVERS_CONFIG=""

for ZK_SERVER in ${ZK_SERVERS}
do
    echo ${ZK_SERVER}
    ZK_SERVERS_CONFIG="${ZK_SERVERS_CONFIG}${ZK_SERVER}:2181,"
done

echo ${ZK_SERVERS_CONFIG}

sed -i "s#/tmp/kafka-logs#${ATLAS_HOME}/log#g" ${ATLAS_CONF}
sed -i "s#zookeeper.connect=localhost:2181#zookeeper.connect=${ZK_SERVERS_CONFIG}#g" ${ATLAS_CONF}
sed -i "s#broker.id=0#broker.id=${SERVER_ID}#g" ${ATLAS_CONF}

#echo "listeners=PLAINTEXT://${SERVER_NAME}:9092" >> ${KAFKA_CONF}

ListenersLine="listeners=PLAINTEXT://${SERVER_NAME}:9092"
echo ${ListenersLine}
if [[ `grep -c "${ListenersLine}" ${ATLAS_CONF}` -eq '0' ]]; then
    printf "\n${ListenersLine}\n" >> ${ATLAS_CONF};
fi

if [[ ! -d ${ATLAS_HOME}/tmp ]]; then
    mkdir ${ATLAS_HOME}/tmp
fi
