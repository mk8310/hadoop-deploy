# 不成熟的 Hadoop 开发环境部署脚本.

## All package version: 
- Hadoop: 2.7.7
- Zookeeper: 3.5.6
- Kafka: 2.11-1.1.0
- Hive: 1.2.2
- HBase: 1.3.6
- Scala: 2.11.8
- Atlas: 1.1.0
- Solr: 7.7.2

## 准备工作：
* 安装服务器，应该不用我告诉你别装 Windows 吧(推荐centos or debian)？PS: 墙裂建议别装 GUI
* 建议安装一个dnsmasq，然后给每台机器弄一个域名，这样你配置起来会轻松很多
* 安装 expect (centos：yum install expect; debian: apt-get install expect)
* 安装 python package：pip install -r requirements.txt
* 按照package version 下载安装包，丢到 remote/packages 目录下，atlas 除外,每个包的文件名分别修改为下面的：
    - Hadoop: hadoop.tar.gz
    - Zookeeper: zookeeper.tar.gz
    - Kafka: kafka.tgz
    - Hive: hive.tar.gz
    - HBase: hbase.tar.gz
    - Scala: scala.tar.gz
    - Solr: solr.tgz
* any more.... 我也不记得做了啥准备了，前面几步做好如果执行有问题可以执行脚本：clear-hadoop-install.sh，求别打

## 执行步骤: 
1. 修改 configs/all-servers.lst, 将所有服务器的地址填到这个文本文件里面.
2. 修改 remote/servers/ 目录下所有的 .lst 文件, 按照不同的作用填写不同的服务器地址清单.
3. 修改 config_manager/config.py 文件第 53 行开始的配置，该配置指定 hive metastore 存放的 mysql 数据库信息.
4. 执行 python 脚本: generate-config.py (for python3.6+) ，生成所有配置文件
5. 执行 install-ssh-keys.sh 脚本, 该脚本完成以下工作:
    1. 生成所有服务器之间 ssh 免登录配置;
    2. 上传各服务器配置、安装脚本、安装包等内容到服务器.
    3. 创建用户
6. 执行 deployment-hadoop.sh 脚本, 该脚本将生成 hadoop&OS 配置并重启服务器. 
7. 执行 format-hadoop-cluster.sh, 该脚本将执行 namenode 的 format.（PS：这一步貌似有bug）
8. 执行 restart-hdfs.sh
9. 分别按以下步骤执行 hbase、hive、kafka、solr、atlas 等目录的脚本：
    1. setup-xxx.sh
    2. start-xxx.sh


## 还没做完的事情：
* hive 没有做 HA
* atlas 还没完善好
* mysql 自行安装，这个脚本不做 mysql 安装
* 用户名和密码啥的还没做配置化，散落在各个sh中，所以。。。密码都用 sz0ByxjoYeTh 哈
* 安装目录统一都是：/opt/cluster 下面，别问为什么，就是懒的做可配置