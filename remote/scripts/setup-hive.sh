#!/usr/bin/env bash

USERNAME=$(id -u -n)
GROUPNAME=$(id -g -n)
CLUSTER_DIR=/opt/cluster/
HADOOP_HOME=/opt/cluster/hadoop
HIVE_HOME=/opt/cluster/hive
REMOTE_DIR=/opt/remote

cd ${CLUSTER_DIR};
if [[ ! -d ${HIVE_HOME} ]]; then
    tar zxvf ${REMOTE_DIR}/packages/hive.tar.gz -C ${CLUSTER_DIR}  > /dev/null
    mv ${CLUSTER_DIR}/apache-hive-1.2.2-bin ${HIVE_HOME}
fi;

cd ${HIVE_HOME}/conf
cp hive-env.sh.template hive-env.sh
cp hive-default.xml.template hive-site.xml
cp hive-log4j.properties.template hive-log4j.properties

while read line; do
    if [[ `grep -c "${line}" ${HIVE_HOME}/conf/hive-env.sh` -eq '0' ]]; then
        echo "${line}" >> ${HIVE_HOME}/conf/hive-env.sh;
    fi
done < ${REMOTE_DIR}/configs/hive-config/hive-env.sh

cat ${REMOTE_DIR}/configs/hive-config/hive-site.xml > ${HIVE_HOME}/conf/hive-site.xml

if [[ `` ]]; then
    sed -i "s#^property\.hive\.log\.dir\s*=\s*.*#property.hive.log.dir = $HIVE_HOME/logs#g" ${HIVE_HOME}/conf/hive-log4j.properties
else
    echo "property.hive.log.dir = ${HIVE_HOME}/logs" >> ${HIVE_HOME}/conf/hive-log4j.properties
fi

if [[ ! -d ${HIVE_HOME}/tmp ]]; then
    mkdir ${HIVE_HOME}/tmp
fi

cp ${REMOTE_DIR}/packages/drivers/* ${HIVE_HOME}/lib/

#cp ${HADOOP_HOME}/share/hadoop/common/lib/guava-27.0-jre.jar ${HIVE_HOME}/lib/guava-19.0.jar

source /etc/profile

schematool -dbType mysql -initSchema
