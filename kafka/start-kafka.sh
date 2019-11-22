#!/usr/bin/env bash

KafkaNodes=`cat ../remote/servers/kafka-nodes.lst`
Port=22
RootName="root"
RootPassword="sz0ByxjoYeTh"
UserName="hduser"
GroupName="hdgroup"
UserPassword="sz0ByxjoYeTh"
KAFKA_HOME=/opt/cluster/kafka
KAFKA_BIN=${KAFKA_HOME}/bin
KAFKA_CONF=${KAFKA_HOME}/config/server.properties

for Host in ${KafkaNodes}
do
    ssh -p ${Port} ${UserName}@${Host} "source /etc/profile ;${KAFKA_BIN}/kafka-server-stop.sh ; ${KAFKA_BIN}/kafka-server-start.sh -daemon ${KAFKA_CONF} &"
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m Start kafka service on $Host success. \033[0m"
    else
        echo -e "\033[31m Start kafka service on $Host failure. \033[0m"
        exit
    fi
done

