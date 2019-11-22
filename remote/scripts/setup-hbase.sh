#!/usr/bin/env bash

USERNAME=$(id -u -n)
GROUPNAME=$(id -g -n)
CLUSTER_DIR=/opt/cluster/
HADOOP_HOME=/opt/cluster/hadoop
HBASE_HOME=/opt/cluster/hbase
REMOTE_DIR=/opt/remote

cd ${CLUSTER_DIR};
if [[ ! -d ${HBASE_HOME} ]]; then
    tar zxvf ${REMOTE_DIR}/packages/hbase.tar.gz -C ${CLUSTER_DIR}  > /dev/null
    mv ${CLUSTER_DIR}/hbase-1.3.6 ${HBASE_HOME}
fi;

cp ${REMOTE_DIR}/configs/hbase-config/hbase-env.sh /tmp/hbase-env.sh.tmp
sed -i "s#HBASEHOME#${HBASE_HOME}#g" /tmp/hbase-env.sh.tmp
sed -i "s#HADOOPHOME#${HADOOP_HOME}#g" /tmp/hbase-env.sh.tmp

while read line; do
    if [[ `grep -c "${line}" ${HBASE_HOME}/conf/hbase-env.sh` -eq '0' ]]; then
        echo "${line}" >> ${HBASE_HOME}/conf/hbase-env.sh;
    fi
done < /tmp/hbase-env.sh.tmp

cat ${REMOTE_DIR}/configs/hbase-config/hbase-site.xml > ${HBASE_HOME}/conf/hbase-site.xml
cat ${REMOTE_DIR}/configs/hbase-config/regionservers > ${HBASE_HOME}/conf/regionservers
cat ${REMOTE_DIR}/configs/hbase-config/backup-masters > ${HBASE_HOME}/conf/backup-masters

if [[ ! -d ${HBASE_HOME}/tmp ]]; then
    mkdir ${HBASE_HOME}/tmp
fi
