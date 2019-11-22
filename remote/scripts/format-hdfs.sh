#!/usr/bin/env bash

source /etc/profile;

UserName=$1
NMSlaveHostList=`cat /opt/remote/servers/slave-name-node.lst`

hdfs namenode -format
hadoop-daemon.sh start namenode

for Host in ${NMSlaveHostList}
do
    ssh ${UserName}@${Host} "source /etc/profile; hdfs namenode -bootstrapStandby; hadoop-daemon.sh start namenode"
done

hdfs zkfc -formatZK
start-dfs.sh