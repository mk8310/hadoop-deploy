#!/usr/bin/env bash

HostList=`cat ./configs/all-servers.lst`
Port=22
RootName="root"
RootPassword="sz0ByxjoYeTh"
UserName="hduser"
GroupName="hdgroup"
UserPassword="sz0ByxjoYeTh"

for Host in ${HostList}
do
    ssh "$UserName@$Host" "echo > ~/.ssh/known_hosts"
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m $Host known_hosts clear success. \033[0m"
    else
        echo -e "\033[31m $Host known_hosts clear failure. \033[0m"
        exit
    fi

    for DestHost in ${HostList}
    do
        echo -e "\033[34m 8. Generate $Host about $DestHost known_hosts. \033[0m"
        ssh "$UserName@$Host" "ssh-keyscan -H $DestHost >> ~/.ssh/known_hosts"
        if [[ $? -eq 0 ]];then
            echo -e "\033[32m $Host about $DestHost known_hosts generate success. \033[0m"
        else
            echo -e "\033[31m $Host about $DestHost known_hosts generate failure. \033[0m"
            exit
        fi
    done
done