#!/usr/bin/env python
# -*-coding:utf-8-*-
"""
Author : Min
date   : 2019/11/21
"""
from config_manager.configs import BaseConfig
from config_manager.renderers import ConfigPropertiesRenderer


class AtlasConfig(BaseConfig):
    def __init__(self, template_file_path: str):
        self.__template_file_path = template_file_path
        super(AtlasConfig, self).__init__(ConfigPropertiesRenderer)

    def read_templates(self, template_file_path: str):
        lines = []
        with open(template_file_path, "r") as file:
            lines.extend(file.readlines())
        for line in lines:
            if line.startswith("#"):
                self._config.add_remark_config(line)
            elif line.strip() == "":
                continue
            else:
                attributes = line.split("=")
                if len(attributes) == 1:
                    attributes.append("")
                elif len(attributes) == 0:
                    continue
                self._config.add_data_config(attributes[0].strip(), attributes[1].strip())

    def _setup(self):
        self.read_templates(self.__template_file_path)
        atlas_node_names = []
        for index in range(len(self._server_config.atlas_node_list)):
            atlas_node_names.append("at%d" % (index + 1))
        zookeeper_server_list = self._server_config.get_zookeeper_server_list()
        self._config.update_data_config(name="atlas.graph.index.search.solr.zookeeper-url",
                                        value=",".join(zookeeper_server_list) + "/solr")
        self._config.update_data_config(name="atlas.graph.storage.hostname",
                                        value=",".join(zookeeper_server_list))
        self._config.update_data_config(name="atlas.kafka.zookeeper.connect",
                                        value=",".join(zookeeper_server_list))
        self._config.update_data_config(name="atlas.server.ha.enabled", value="true")
        for index in range(len(self._server_config.atlas_node_list)):
            node_name = atlas_node_names[index]
            node_url = self._server_config.atlas_node_list[index]
            self._config.update_data_config(name="atlas.server.address.%s" % node_name, value="%s:21000" % node_url)
        # self._config.add_data_config(name="atlas.rest.address", value="")
        self._config.update_data_config(name="atlas.server.ids", value=",".join(atlas_node_names))
