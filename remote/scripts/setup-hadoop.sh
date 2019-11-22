#!/usr/bin/env bash

USERNAME=$(id -u -n)
GROUPNAME=$(id -g -n)
CLUSTER_DIR=/opt/cluster/
HADOOP_HOME=/opt/cluster/hadoop
REMOTE_DIR=/opt/remote

cd /opt/cluster/;
if [[ ! -d ${HADOOP_HOME} ]]; then
    tar zxvf ${REMOTE_DIR}/packages/hadoop.tar.gz -C ${CLUSTER_DIR}  > /dev/null
    mv ${CLUSTER_DIR}/hadoop-2.7.7 ${CLUSTER_DIR}/hadoop
fi;

cp ${REMOTE_DIR}/configs/hadoop-config/hadoop-env.sh /tmp/hadoop-env.sh.tmp
sed -i "s/username/${USERNAME}/g" /tmp/hadoop-env.sh.tmp

while read line; do
    if [[ `grep -c "${line}" ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh` -eq '0' ]]; then
        echo "${line}" >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh;
    fi
done < /tmp/hadoop-env.sh.tmp

if [[ ! -d ${HADOOP_HOME}/hdfs ]]; then
    mkdir ${HADOOP_HOME}/hdfs
fi

if [[ ! -d ${HADOOP_HOME}/hdfs/tmp ]]; then
    mkdir ${HADOOP_HOME}/hdfs/tmp
fi

if [[ ! -d ${HADOOP_HOME}/hdfs/name ]]; then
    mkdir ${HADOOP_HOME}/hdfs/name
fi

if [[ ! -d ${HADOOP_HOME}/hdfs/data ]]; then
    mkdir ${HADOOP_HOME}/hdfs/data
fi

if [[ ! -d ${HADOOP_HOME}/hdfs/journaldata ]]; then
    mkdir ${HADOOP_HOME}/hdfs/journaldata
fi

source /etc/profile

cat ${REMOTE_DIR}/configs/hadoop-config/core-site.xml > ${HADOOP_HOME}/etc/hadoop/core-site.xml
cat ${REMOTE_DIR}/configs/hadoop-config/hdfs-site.xml > ${HADOOP_HOME}/etc/hadoop/hdfs-site.xml
cat ${REMOTE_DIR}/configs/hadoop-config/mapred-site.xml > ${HADOOP_HOME}/etc/hadoop/mapred-site.xml
cat ${REMOTE_DIR}/configs/hadoop-config/yarn-site.xml > ${HADOOP_HOME}/etc/hadoop/yarn-site.xml
cat ${REMOTE_DIR}/configs/hadoop-config/slaves > ${HADOOP_HOME}/etc/hadoop/slaves
cat ${REMOTE_DIR}/configs/hadoop-config/workers > ${HADOOP_HOME}/etc/hadoop/workers
