#!/usr/bin/env bash

ServerId=$1
UserName=$(id -u -n)
GroupName=$(id -g -n)
CLUSTER_DIR=/opt/cluster/
ZOOKEEPER_HOME=/opt/cluster/zookeeper
SCRIPT_DIR=/opt/remote

if [[ ! -d ${ZOOKEEPER_HOME} ]]; then
    tar zxvf ${SCRIPT_DIR}/packages/zookeeper.tar.gz -C ${CLUSTER_DIR}/  > /dev/null
    mv ${CLUSTER_DIR}/apache-zookeeper-3.5.6-bin ${CLUSTER_DIR}/zookeeper
fi;

if [[ ! -d  ${ZOOKEEPER_HOME}/tmp ]]; then
    mkdir ${ZOOKEEPER_HOME}/tmp
    echo ${ServerId} > ${ZOOKEEPER_HOME}/tmp/myid
fi

cp ${ZOOKEEPER_HOME}/conf/zoo_sample.cfg ${ZOOKEEPER_HOME}/conf/zoo.cfg
sed -i s#/tmp/zookeeper#${ZOOKEEPER_HOME}/tmp# ${ZOOKEEPER_HOME}/conf/zoo.cfg
INDEX=1
for Host in `cat ${SCRIPT_DIR}/servers/zookeepers.lst`
do
    echo server.${INDEX}=${Host}:2888:3888 >> ${ZOOKEEPER_HOME}/conf/zoo.cfg
    let INDEX=${INDEX}+1
done