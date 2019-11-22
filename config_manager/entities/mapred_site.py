#!/usr/bin/env python
# -*-coding:utf-8-*-
"""
Author : Min
date   : 2019/11/21
"""

from config_manager.configs import BaseConfig
from config_manager.renderers import ConfigXmlRenderer


class MapredSiteConfig(BaseConfig):
    def __init__(self):
        super(MapredSiteConfig, self).__init__(ConfigXmlRenderer)

    def _setup(self):
        self._config.add_data_config(name="mapreduce.framework.name", value="yarn")
        self._config.add_data_config(name="yarn.app.mapreduce.am.env",
                                     value="HADOOP_MAPRED_HOME=%s" % self._server_config.hadoop_home)
        self._config.add_data_config(name="mapreduce.map.env",
                                     value="HADOOP_MAPRED_HOME=%s" % self._server_config.hadoop_home)
        self._config.add_data_config(name="mapreduce.reduce.env",
                                     value="HADOOP_MAPRED_HOME=%s" % self._server_config.hadoop_home)
        self._config.add_data_config(name="mapreduce.jobhistory.address",
                                     value="%s:10020" % self._server_config.master_name_node)
        self._config.add_data_config(name="mapreduce.jobhistory.webapp.address",
                                     value="%s:19888" % self._server_config.master_name_node)
