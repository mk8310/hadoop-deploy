#!/usr/bin/env bash

HostList=`cat ./configs/all-servers.lst`
ZKHostList=`cat ./remote/servers/zookeepers.lst`
JNHostList=`cat ./remote/servers/journal-nodes.lst`
NNMasterHost=`cat ./remote/servers/master-name-node.lst`
YARNMasterHost=`cat ./remote/servers/yarn-master-node.lst`
Port=22
RootName="root"
RootPassword="sz0ByxjoYeTh"
UserName="hduser"
GroupName="hdgroup"
UserPassword="sz0ByxjoYeTh"
HADOOP_HOME=/opt/cluster/hadoop
ZOOKEEPER_HOME=/opt/cluster/zookeeper


function pause(){
        read -n 1 -p "$*" INP
        if [[ ${INP} != '' ]] ; then
                echo -ne '\b \n'
        fi
}

for Host in ${ZKHostList}
do
    echo -e "\033[34m 1. Start zookeeper for $Host. \033[0m"
    ssh -p ${Port} ${UserName}@${Host} "source /etc/profile; ${ZOOKEEPER_HOME}/bin/zkServer.sh start"
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m Start zookeeper for $Host success. \033[0m"
    else
        echo -e "\033[31m Start zookeeper for $Host failure. \033[0m"
        exit
    fi
done

for Host in ${JNHostList}
do
    echo -e "\033[34m 2. Start hadoop journal node for $Host. \033[0m"
    ssh -p ${Port} ${UserName}@${Host} "source /etc/profile; ${HADOOP_HOME}/sbin/hadoop-daemon.sh start journalnode &"
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m Start hadoop journal node for $Host success. \033[0m"
    else
        echo -e "\033[31m Start hadoop journal node for $Host failure. \033[0m"
        exit
    fi
done

sleep 5

for Host in ${ZKHostList}
do
    ssh -p ${Port} ${UserName}@${Host} "source /etc/profile; ${ZOOKEEPER_HOME}/bin/zkServer.sh status"
done
pause 'Press any key to continue...'

for Host in ${JNHostList}
do
    ssh -p ${Port} ${UserName}@${Host} "source /etc/profile; jps"
done

pause 'Press any key to continue...'


for Host in ${NNMasterHost}
do
    echo -e "\033[34m 3. First start hdfs at ${Host}. \033[0m"
    ssh -p ${Port} ${UserName}@${Host} "sh /opt/remote/scripts/format-hdfs.sh ${UserName}"
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m First start hdfs at ${Host} success. \033[0m"
    else
        echo -e "\033[31m First start hdfs at ${Host} failure. \033[0m"
        exit
    fi
done

for Host in ${YARNMasterHost}
do
    echo -e "\033[34m 3. Start yarn at ${Host}. \033[0m"
    ssh -p ${Port} ${UserName}@${Host} "source /etc/profile; ${HADOOP_HOME}/sbin/start-yarn.sh"
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m Start yarn at ${Host} success. \033[0m"
    else
        echo -e "\033[31m Start yarn at ${Host} failure. \033[0m"
        exit
    fi
done

for Host in ${HostList}
do
    ssh -p ${Port} ${UserName}@${Host} "source /etc/profile; jps"
done

pause 'Press any key to continue...'
