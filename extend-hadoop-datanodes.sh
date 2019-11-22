#!/usr/bin/env bash

HostList=`cat ./configs/all-servers.lst`
Port=22
RootName="root"
RootPassword="sz0ByxjoYeTh"
UserName="hduser"
GroupName="hdgroup"
UserPassword="sz0ByxjoYeTh"
HADOOP_HOME=/opt/cluster/hadoop
REMOTE_DIR=/opt/remote

python3 ./generate-config.py
upload.sh server-list
upload.sh configs
upload.sh

for Host in ${HostList}
do
    ssh ${UserName}@${Host} "sh ${REMOTE_DIR}/scripts/setup-hadoop.sh"
done

restart-hdfs.sh