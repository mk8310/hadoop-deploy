export HADOOP_HOME="/opt/cluster/hadoop"
export ZK_HOME="/opt/cluster/zookeeper"
export HIVE_HOME="/opt/cluster/hive"
export HBASE_HOME="/opt/cluster/hbase"
export FLINK_HOME="/opt/cluster/flink"
export SPARK_HOME="/opt/cluster/spark"
export KAFKA_HOME="/opt/cluster/kafka"
export SOLR_HOME="/opt/cluster/solr"

export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$ZK_HOME/bin:$PATH:$HIVE_HOME/bin
export PATH=$PATH:$HBASE_HOME/bin:$FLINK_HOME/bin:$SPARK_HOME/bin:${KAFKA_HOME}/bin:${SOLR_HOME}/bin

export _JAVA_OPTIONS="-Djava.net.preferIPv4Stack=true"
