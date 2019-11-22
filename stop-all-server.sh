#!/usr/bin/env bash

Servers=`cat servers.lst`
Port=22
RootName="root"

for Host in ${Servers}
do
    ssh -p ${Port} ${RootName}@${Host} "shutdown -h now &"
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m Shutdown os on $Host success. \033[0m"
    else
        echo -e "\033[31m Shutdown os on $Host failure. \033[0m"
        exit
    fi
done

