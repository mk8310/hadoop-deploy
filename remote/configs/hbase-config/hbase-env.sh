export JAVA_HOME=/usr/local/jdk1.8
export HBASE_MANAGES_ZK=false
export HBASE_OPTS="$HBASE_OPTS -XX:+HeapDumpOnOutOfMemoryError -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode"
export HBASE_HOME=HBASEHOME
export HADOOP_HOME=HADOOPHOME