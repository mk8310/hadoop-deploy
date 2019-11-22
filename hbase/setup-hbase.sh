#!/usr/bin/env bash

HBaseMasters=`cat ../remote/servers/hbase-masters.lst`
HBaseRegions=`cat ../remote/servers/hbase-regions.lst`
Port=22
RootName="root"
RootPassword="sz0ByxjoYeTh"
UserName="hduser"
GroupName="hdgroup"
UserPassword="sz0ByxjoYeTh"

function remote_setup() {
    Host=$1
    echo -e "\033[34m 1. Setup $Host system config. \033[0m"
    ssh -p ${Port} ${RootName}@${Host} "/opt/remote/scripts/setup-os.sh ${UserName} ${GroupName}"
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m Setup $Host system config success. \033[0m"
    else
        echo -e "\033[31m Setup $Host system config failure. \033[0m"
        exit
    fi

    echo -e "\033[34m 2. Setup $Host hbase config. \033[0m"
    ssh -p ${Port} ${UserName}@${Host} "sh /opt/remote/scripts/setup-hbase.sh"
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m Setup $Host hbase config success. \033[0m"
    else
        echo -e "\033[31m Setup $Host hbase config failure. \033[0m"
        exit
    fi
}

for Host in ${HBaseMasters}
do
    remote_setup ${Host}
done

for Host in ${HBaseRegions}
do
    remote_setup ${Host}
done