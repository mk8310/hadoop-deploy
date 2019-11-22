#!/usr/bin/env bash

SolrNodes=`cat ../remote/servers/solr-nodes.lst`
Port=22
RootName="root"
RootPassword="sz0ByxjoYeTh"
UserName="hduser"
GroupName="hdgroup"
UserPassword="sz0ByxjoYeTh"
SOLR_HOME=/opt/cluster/solr
ZK_SERVERS=`cat ../remote/servers/zookeepers.lst`

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

    echo -e "\033[34m 2. Setup $Host solr config. \033[0m"
    ssh -p ${Port} ${UserName}@${Host} "sh /opt/remote/scripts/setup-solr.sh ${INDEX} ${Host}"
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m Setup $Host solr config success. \033[0m"
    else
        echo -e "\033[31m Setup $Host solr config failure. \033[0m"
        exit
    fi

    echo -e "\033[34m 2. Setup $Host solr config. \033[0m"
    ssh -p ${Port} ${UserName}@${Host} "source /etc/profile; ${SOLR_HOME}/bin/solr stop; ${SOLR_HOME}/bin/solr start -c &"
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m Setup $Host solr config success. \033[0m"
    else
        echo -e "\033[31m Setup $Host solr config failure. \033[0m"
        exit
    fi
}

function create_collection() {
    Host=$1
    echo -e "\033[34m 3. Create solr collection on cluster. \033[0m"
    ssh -p ${Port} ${UserName}@${Host} "source /etc/profile; ${SOLR_HOME}/bin/solr create -c core1-s 2 -rf 2 -force"
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m Create solr collection on cluster success. \033[0m"
    else
        echo -e "\033[31m Create solr collection on cluster failure. \033[0m"
        exit
    fi

    ZK_SERVERS_CONFIG=""

    for ZK_SERVER in ${ZK_SERVERS}
    do
        echo ${ZK_SERVER}
        ZK_SERVERS_CONFIG="${ZK_SERVERS_CONFIG}${ZK_SERVER}:2181,"
    done


    echo -e "\033[34m 4. Upload solr configurations to zookeeper. \033[0m"
    ssh -p ${Port} ${UserName}@${Host} "${SOLR_HOME}/bin/zkcli.sh -zkhost ${ZK_SERVERS_CONFIG} -cmd upconfig -confdir ${SOLR_HOME}/server/solr/configsets/_default/conf/ -confname solrconfig"
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m Upload solr configurations to zookeeper success. \033[0m"
    else
        echo -e "\033[31m Upload solr configurations to zookeeper failure. \033[0m"
        exit
    fi
}

FirstNode=""
INDEX=1
for Host in ${SolrNodes}
do
    if [[ ${INDEX} -eq 1 ]]; then
        FirstNode=${Host}
    fi
    remote_setup ${Host} ${INDEX}
    let INDEX=${INDEX}+1
done

#create_collection ${FirstNode}