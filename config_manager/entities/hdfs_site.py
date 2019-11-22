#!/usr/bin/env python
# -*-coding:utf-8-*-
"""
Author : Min
date   : 2019/11/21
"""

from config_manager.configs import BaseConfig
from config_manager.renderers import ConfigXmlRenderer


class HDFSSiteConfig(BaseConfig):
    def __init__(self):
        super(HDFSSiteConfig, self).__init__(ConfigXmlRenderer)

    def _setup(self):
        replication_count = len(self._server_config.data_node_list) - 1
        if len(self._server_config.data_node_list) <= 2:
            replication_count = len(self._server_config.data_node_list)
        jn_nodes = [jn_node + ":8485" for jn_node in self._server_config.journal_node_list]

        self._config.add_data_config(name="dfs.nameservices", value=self._server_config.hdfs_namespace)
        self._config.add_data_config(name="dfs.ha.namenodes.%s" % self._server_config.hdfs_namespace,
                                     value=",".join(self._server_config.name_node_names))

        self._config.add_data_config(name="dfs.replication", value=str(replication_count))
        for index in range(len(self._server_config.name_node_names)):
            node_name = self._server_config.name_node_names[index]
            node_url = self._server_config.name_node_list[index]
            self._config.add_data_config(
                name="dfs.namenode.rpc-address.%s.%s" % (self._server_config.hdfs_namespace, node_name),
                value="%s:8020" % node_url)
            self._config.add_data_config(
                name="dfs.namenode.http-address.%s.%s" % (self._server_config.hdfs_namespace, node_name),
                value="%s:50070" % node_url)
        self._config.add_data_config(name="dfs.namenode.shared.edits.dir",
                                     value="qjournal://%s/%s" % (";".join(jn_nodes), self._server_config.hdfs_namespace)
                                     )

        self._config.add_data_config(name="dfs.namenode.name.dir",
                                     value="file:%s/hdfs/name" % self._server_config.hadoop_home)
        self._config.add_data_config(name="dfs.datanode.data.dir",
                                     value="file:%s/hdfs/data" % self._server_config.hadoop_home)
        self._config.add_data_config(name="dfs.journalnode.data.dir",
                                     value="file:%s/hdfs/journaldata" % self._server_config.hadoop_home)
        self._config.add_data_config(name="dfs.ha.automatic-failover.enabled", value="true")
        self._config.add_data_config(name="dfs.client.failover.proxy.provider.%s" % self._server_config.hdfs_namespace,
                                     value="org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider")
        self._config.add_data_config(name="dfs.ha.fencing.methods", value="sshfence\nshell(/bin/true)")
        self._config.add_data_config(name="dfs.ha.fencing.ssh.private-key-files",
                                     value="/home/%s/.ssh/id_rsa" % self._server_config.os_user)
        self._config.add_data_config(name="dfs.namenode.datanode.registration.ip-hostname-check", value="false")
        self._config.add_data_config(name="dfs.ha.fencing.ssh.connect-timeout", value="30000")
