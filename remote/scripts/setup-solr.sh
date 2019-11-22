#!/usr/bin/env bash

SERVER_ID=$1
SERVER_NAME=$2
USERNAME=$(id -u -n)
GROUPNAME=$(id -g -n)
CLUSTER_DIR=/opt/cluster/
HADOOP_HOME=/opt/cluster/hadoop
SOLR_ROOT=/opt/cluster/solr
SOLR_HOME=${SOLR_ROOT}/home
REMOTE_DIR=/opt/remote
SOLR_CONF=${SOLR_ROOT}/bin/solr.in.sh
ZK_SERVERS=`cat ${REMOTE_DIR}/servers/zookeepers.lst`

cd ${CLUSTER_DIR};
if [[ ! -d ${SOLR_ROOT} ]]; then
    tar zxvf ${REMOTE_DIR}/packages/solr.tgz -C ${CLUSTER_DIR}  > /dev/null
    mv ${CLUSTER_DIR}/solr-7.7.2 ${SOLR_ROOT}
fi;

if [[ ! -d ${SOLR_ROOT}/log ]]; then
    mkdir -p ${SOLR_ROOT}/log
fi

if [[ ! -d ${SOLR_ROOT}/home ]]; then
    mkdir -p ${SOLR_ROOT}/home
fi


ZK_SERVERS_CONFIG=""

for ZK_SERVER in ${ZK_SERVERS}
do
    echo ${ZK_SERVER}
    ZK_SERVERS_CONFIG="${ZK_SERVERS_CONFIG}${ZK_SERVER}:2181,"
done

cp ${SOLR_ROOT}/server/solr/solr.xml ${SOLR_HOME}/solr.xml

ZK_HOST_CONF="ZK_HOST=\"${ZK_SERVERS_CONFIG}/solr\""
if [[ `grep -c ${ZK_HOST_CONF} ${SOLR_CONF}` -eq '0' ]]; then
    echo ${ZK_HOST_CONF} >> ${SOLR_CONF}
fi

SOLR_HOST_CONF="SOLR_HOST=\"${SERVER_NAME}\""
if [[ `grep -c ${SOLR_HOST_CONF} ${SOLR_CONF}` -eq '0' ]]; then
    echo ${SOLR_HOST_CONF} >> ${SOLR_CONF}
fi

SOLR_PORT_CONF="SOLR_PORT=8981"
if [[ `grep -c ${SOLR_PORT_CONF} ${SOLR_CONF}` -eq '0' ]]; then
    echo ${SOLR_PORT_CONF} >> ${SOLR_CONF}
fi

SOLR_HOME_CONF="SOLR_HOME=${SOLR_HOME}"
if [[ `grep -c ${SOLR_HOME_CONF} ${SOLR_CONF}` -eq '0' ]]; then
    echo ${SOLR_HOME_CONF} >> ${SOLR_CONF}
fi
