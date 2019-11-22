#!/usr/bin/env python
# -*-coding:utf-8-*-
"""
Author : Min
date   : 2019/11/21
"""
import os

from config_manager.configs import BaseConfig
from config_manager.renderers import ConfigXmlRenderer


class HiveSiteConfig(BaseConfig):
    def __init__(self):
        super(HiveSiteConfig, self).__init__(ConfigXmlRenderer)

    def _setup(self):
        self._config.add_data_config(name="system:java.io.tmpdir",
                                     value=os.path.join(self._server_config.hive_home, "tmp"))
        self._config.add_data_config(name="system:user.name", value="${user.name}")
        self._config.add_data_config(name="jdbc.driverClass", value="com.mysql.cj.jdbc.Driver")
        self._config.add_data_config(name="javax.jdo.option.ConnectionUserName",
                                     value=self._server_config.hive_metadb_user)
        self._config.add_data_config(name="javax.jdo.option.ConnectionPassword",
                                     value=self._server_config.hive_metadb_password)
        connection_string = \
            "jdbc:mysql://{host}:{port}/hive?createDatabaseIfNotExist=true&amp;characterEncoding=UTF-8&amp;useSSL={useSSL}" \
                .format(host=self._server_config.hive_metadb_host,
                        port=self._server_config.hive_metadb_port,
                        useSSL=str(self._server_config.hive_metadb_useSSL).lower())
        self._config.add_data_config(name="javax.jdo.option.ConnectionURL",
                                     value=connection_string)

        self._config.add_data_config(name="javax.jdo.option.ConnectionDriverName", value="com.mysql.cj.jdbc.Driver")
        self._config.add_data_config(name="hive.metastore.schema.verification", value="false")
