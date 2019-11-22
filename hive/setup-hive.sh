#!/usr/bin/env bash

HiveHosts=`cat ../remote/servers/hives.lst`
Port=22
RootName="root"
RootPassword="sz0ByxjoYeTh"
UserName="hduser"
GroupName="hdgroup"
UserPassword="sz0ByxjoYeTh"

for Host in ${HiveHosts}
do
    echo -e "\033[34m 1. Setup $Host system config. \033[0m"
    ssh -p ${Port} ${RootName}@${Host} "/opt/remote/scripts/setup-os.sh ${UserName} ${GroupName}"
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m Setup $Host system config success. \033[0m"
    else
        echo -e "\033[31m Setup $Host system config failure. \033[0m"
        exit
    fi

    echo -e "\033[34m 2. Setup $Host hive config. \033[0m"
    ssh -p ${Port} ${UserName}@${Host} "sh /opt/remote/scripts/setup-hive.sh"
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m Setup $Host hive config success. \033[0m"
    else
        echo -e "\033[31m Setup $Host hive config failure. \033[0m"
        exit
    fi
done