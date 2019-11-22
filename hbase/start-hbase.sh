#!/usr/bin/env bash


HiveHosts=`cat ../remote/servers/hbase-master.lst`
Port=22
RootName="root"
RootPassword="sz0ByxjoYeTh"
UserName="hduser"
GroupName="hdgroup"
UserPassword="sz0ByxjoYeTh"

for Host in ${HiveHosts}
do
    echo -e "\033[34m 1. Start hbase on $Host. \033[0m"
    ssh -p ${Port} ${UserName}@${Host} "source /etc/profile; start-hbase.sh &"
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m Start hbase on $Host success. \033[0m"
    else
        echo -e "\033[31m Start hbase on $Host failure. \033[0m"
        exit
    fi

done
