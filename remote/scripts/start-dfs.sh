#!/usr/bin/env bash

source /etc/profile;

CLUSTER_DIR=/opt/cluster/
HADOOP_HOME=/opt/cluster/hadoop
REMOTE_DIR=/opt/remote

UserName=$1
NMSlaveHostList=`cat /opt/remote/servers/slave-name-node.lst`

hadoop-daemon.sh start namenode

for Host in ${NMSlaveHostList}
do
    ssh ${UserName}@${Host} "source /etc/profile; hdfs namenode -bootstrapStandby; hadoop-daemon.sh start namenode"
done

start-dfs.sh