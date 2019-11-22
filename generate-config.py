#!/usr/bin/env python
# -*-coding:utf-8-*-
"""
Author : Min
date   : 2019/11/13
"""
import os

from config_manager.configs import ServerNodeConfig
from config_manager.entities.atlas import AtlasConfig
from config_manager.entities.core_site import CoreSiteConfig
from config_manager.entities.hbase import HBaseSiteConfig
from config_manager.entities.hdfs_site import HDFSSiteConfig
from config_manager.entities.hive_site import HiveSiteConfig
from config_manager.entities.mapred_site import MapredSiteConfig
from config_manager.entities.yarn_site import YarnSiteConfig


class ConfigHelper(object):
    def __init__(self):
        self._server_config = ServerNodeConfig()

    @staticmethod
    def __get_server_list(filename):
        file_path = os.path.join("./remote/servers/", filename)
        with open(file_path, "r") as file:
            content = file.read()
        server_list = content.split("\n")
        for server in server_list:
            if not server:
                server_list.remove(server)
        return server_list

    @staticmethod
    def __save_config_file(dirname, filename, content):
        file_path = os.path.join("./remote/configs/", dirname, filename)
        with open(file_path, "w", encoding="utf-8") as file:
            file.write(content)

    def gen_core_site(self):
        core_config = CoreSiteConfig()
        self.__save_config_file("hadoop-config", "core-site.xml", core_config.render())

    def gen_hdfs_site(self):
        hdfs_config = HDFSSiteConfig()
        self.__save_config_file("hadoop-config", "hdfs-site.xml", hdfs_config.render())

    def gen_mapred_site(self):
        mr_config = MapredSiteConfig()

        self.__save_config_file("hadoop-config", "mapred-site.xml", mr_config.render())

    def gen_yarn_site(self):
        yarn_config = YarnSiteConfig()

        self.__save_config_file("hadoop-config", "yarn-site.xml", yarn_config.render())

    def gen_data_node_list(self):
        self.__save_config_file("hadoop-config", "workers", "\n".join(self._server_config.data_node_list))
        self.__save_config_file("hadoop-config", "slaves", "\n".join(self._server_config.data_node_list))

    def gen_hive_site(self):
        hive_config = HiveSiteConfig()

        self.__save_config_file("hive-config", "hive-site.xml", hive_config.render())

    def gen_hbase_site(self):
        hbase_config = HBaseSiteConfig()
        self.__save_config_file("hbase-config", "hbase-site.xml", hbase_config.render())

    def gen_hbase_nodes(self):
        hbase_masters = []
        hbase_masters.extend(self._server_config.hbase_master_list)
        hbase_masters.remove(self._server_config.hbase_master_node)
        self.__save_config_file("hbase-config", "regionservers", "\n".join(self._server_config.hbase_region_list))
        self.__save_config_file("hbase-config", "backup-masters", "\n".join(hbase_masters))

    def gen_atlas_config(self):
        template_path = os.path.join(os.path.dirname(__file__), "config_manager/templates/atlas-application.properties")
        atlas_config = AtlasConfig(template_path)
        self.__save_config_file("atlas-config", "atlas-application.properties", atlas_config.render())


def main():
    config_helper = ConfigHelper()
    config_helper.gen_core_site()
    config_helper.gen_hdfs_site()
    config_helper.gen_yarn_site()
    config_helper.gen_mapred_site()
    config_helper.gen_data_node_list()
    config_helper.gen_hive_site()
    config_helper.gen_hbase_site()
    config_helper.gen_hbase_nodes()
    config_helper.gen_atlas_config()


if __name__ == '__main__':
    main()
