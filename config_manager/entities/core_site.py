#!/usr/bin/env python
# -*-coding:utf-8-*-
"""
Author : Min
date   : 2019/11/21
"""
from config_manager.configs import BaseConfig
from config_manager.renderers import ConfigXmlRenderer


class CoreSiteConfig(BaseConfig):
    def __init__(self):
        super(CoreSiteConfig, self).__init__(ConfigXmlRenderer)

    def _setup(self):
        zookeeper_server_list = self._server_config.get_zookeeper_server_list()
        self._config.add_data_config(
            name="fs.defaultFS", value="hdfs://{namespace}".format(namespace=self._server_config.hdfs_namespace))
        self._config.add_data_config(name="hadoop.tmp.dir", value="/opt/cluster/hadoop/hdfs/tmp")
        self._config.add_data_config(name="ha.zookeeper.quorum", value=",".join(zookeeper_server_list))
