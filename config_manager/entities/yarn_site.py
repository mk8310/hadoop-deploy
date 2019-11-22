#!/usr/bin/env python
# -*-coding:utf-8-*-
"""
Author : Min
date   : 2019/11/21
"""

from config_manager.configs import BaseConfig
from config_manager.renderers import ConfigXmlRenderer


class YarnSiteConfig(BaseConfig):
    def __init__(self):
        super(YarnSiteConfig, self).__init__(ConfigXmlRenderer)

    def _setup(self):
        zookeeper_server_list = self._server_config.get_zookeeper_server_list()
        self._config.add_data_config(name="yarn.resourcemanager.ha.enabled", value="true")
        self._config.add_data_config(name="yarn.resourcemanager.cluster-id", value=self._server_config.rm_cluster_name)

        self._config.add_data_config(name="yarn.resourcemanager.ha.rm-ids",
                                     value=",".join(self._server_config.rm_node_names))

        for index in range(len(self._server_config.rm_node_names)):
            node_name = self._server_config.rm_node_names[index]
            node_url = self._server_config.resource_manager_list[index]
            self._config.add_data_config(name="yarn.resourcemanager.hostname.%s" % node_name,
                                         value="%s" % node_url)
            self._config.add_data_config(name="yarn.resourcemanager.webapp.address.%s" % node_name,
                                         value="%s:8088" % node_url)

        self._config.add_data_config(name="yarn.resourcemanager.zk-address", value=",".join(zookeeper_server_list))
        self._config.add_data_config(name="yarn.nodemanager.aux-services", value="mapreduce_shuffle")
        self._config.add_data_config(name="yarn.log-aggregation-enable", value="true")
        self._config.add_data_config(name="yarn.log-aggregation.retain-seconds", value="106800")
