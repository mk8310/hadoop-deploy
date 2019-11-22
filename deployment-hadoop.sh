#!/usr/bin/env bash

# machine list
HostList=`cat ./configs/all-servers.lst`
ZKHostList=`cat ./remote/servers/zookeepers.lst`
# port
Port=22
RootName="root"
RootPassword="sz0ByxjoYeTh"
UserName="hduser"
GroupName="hdgroup"
UserPassword="sz0ByxjoYeTh"

for Host in ${HostList}
do
    echo -e "\033[34m 10. Setup $Host system config. \033[0m"
    ssh -p ${Port} ${RootName}@${Host} "/opt/remote/scripts/setup-os.sh ${UserName} ${GroupName}"
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m Setup $Host system config success. \033[0m"
    else
        echo -e "\033[31m Setup $Host system config failure. \033[0m"
        exit
    fi
done

INDEX=1
for Host in ${ZKHostList}
do
    echo -e "\033[34m 9. Setup $Host zookeeper config. \033[0m"
    ssh -p ${Port} ${UserName}@${Host} "sh /opt/remote/scripts/setup-zk.sh ${INDEX}"
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m Setup $Host zookeeper config success. \033[0m"
    else
        echo -e "\033[31m Setup $Host zookeeper config failure. \033[0m"
        exit
    fi
    let INDEX=${INDEX}+1
done

for Host in ${HostList}
do
    echo -e "\033[34m 11. Setup $Host hadoop config. \033[0m"
    ssh -p ${Port} ${UserName}@${Host} "sh /opt/remote/scripts/setup-hadoop.sh"
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m Setup $Host hadoop config success. \033[0m"
    else
        echo -e "\033[31m Setup $Host hadoop config failure. \033[0m"
        exit
    fi

done

for Host in ${HostList}
do
    echo -e "\033[34m 12. Reboot $Host. \033[0m"
    ssh -p ${Port} ${RootName}@${Host} "reboot& "
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m $Host reboot success. \033[0m"
    else
        echo -e "\033[31m $Host reboot failure. \033[0m"
        exit
    fi
done