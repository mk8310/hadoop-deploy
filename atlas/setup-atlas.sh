#!/usr/bin/env bash

KafkaNodes=`cat ../remote/servers/kafka-nodes.lst`
Port=22
RootName="root"
RootPassword="sz0ByxjoYeTh"
UserName="hduser"
GroupName="hdgroup"
UserPassword="sz0ByxjoYeTh"

function remote_setup() {
    Host=$1
    INDEX=$2
    echo -e "\033[34m 1. Setup $Host system config. \033[0m"
    ssh -p ${Port} ${RootName}@${Host} "/opt/remote/scripts/setup-os.sh ${UserName} ${GroupName}"
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m Setup $Host system config success. \033[0m"
    else
        echo -e "\033[31m Setup $Host system config failure. \033[0m"
        exit
    fi

    echo -e "\033[34m 2. Setup $Host hbase config. \033[0m"
    ssh -p ${Port} ${UserName}@${Host} "sh /opt/remote/scripts/setup-kafka.sh ${INDEX} ${Host}"
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m Setup $Host hbase config success. \033[0m"
    else
        echo -e "\033[31m Setup $Host hbase config failure. \033[0m"
        exit
    fi
}

INDEX=1
for Host in ${KafkaNodes}
do
    remote_setup ${Host} ${INDEX}
    let INDEX=${INDEX}+1
done
