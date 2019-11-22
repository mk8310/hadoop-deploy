#!/usr/bin/env python
# -*-coding:utf-8-*-
"""
Author : Min
date   : 2019/11/21
"""

from config_manager.configs import BaseConfig
from config_manager.renderers import ConfigXmlRenderer


class HBaseSiteConfig(BaseConfig):
    def __init__(self):
        super(HBaseSiteConfig, self).__init__(ConfigXmlRenderer)

    def _setup(self):
        zookeeper_server_list = self._server_config.get_zookeeper_server_list()
        self._config.add_data_config(name="hbase.rootdir",
                                     value="hdfs://%s/hbase" % self._server_config.master_name_node)
        self._config.add_data_config(name="hbase.cluster.distributed", value="true")
        self._config.add_data_config(name="hbase.zookeeper.quorum", value=",".join(zookeeper_server_list))
        self._config.add_data_config(name="hbase.master.info.port", value="60010")
