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
    echo -e "\033[34m 1. Start hiveserver2 on $Host. \033[0m"
    ssh -p ${Port} ${UserName}@${Host} "source /etc/profile; hive --service hiveserver2 &"
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m Start hiveserver2 on $Host success. \033[0m"
    else
        echo -e "\033[31m Start hiveserver2 on $Host failure. \033[0m"
        exit
    fi
az
done
