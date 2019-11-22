#!/usr/bin/env python
# -*-coding:utf-8-*-
"""
Author : Min
date   : 2019/11/21
"""
from abc import ABC, abstractmethod
from enum import Enum

from config_manager.models import ConfigNode, Configuration, ConfigRemarkNode, ConfigDataNode


class OutputType(Enum):
    xml = 0
    properties = 1


class ConfigRenderer(object):
    __metaclass__ = ABC

    def __init__(self, configurations: Configuration):
        self._configurations = configurations

    @abstractmethod
    def render(self) -> str:
        pass


class ConfigPropertiesRenderer(ConfigRenderer):
    def render(self) -> str:
        content_list = []
        for node in self._configurations:
            node_renderer = ConfigNodePropertiesRenderer(node)
            content_list.append(node_renderer.render())
        return "\n".join(content_list)


class ConfigXmlRenderer(ConfigRenderer):
    def render(self) -> str:
        result = ["<configuration>"]
        for config_property in self._configurations:
            result.append(str(config_property))
        result.append("</configuration>")
        return "\n".join(result)


class ConfigNodeRenderer():
    __metaclass__ = ABC

    def __init__(self, node: ConfigNode):
        self._node = node

    def render(self) -> str:
        if isinstance(self._node, ConfigRemarkNode):
            return self._render_remark_node(self._node)
        elif isinstance(self._node, ConfigDataNode):
            return self._render_config_data(self._node)

    @abstractmethod
    def _render_config_data(self, node: ConfigDataNode) -> str:
        pass

    def _render_remark_node(self, node: ConfigRemarkNode):
        description = node.description
        return self._render_remark(description)

    @abstractmethod
    def _render_remark(self, description: str) -> str:
        pass


class ConfigNodeXmlRenderer(ConfigNodeRenderer):
    def _render_remark(self, description: str) -> str:
        return "<!-- %s -->" % description

    def _render_config_data(self, node: ConfigDataNode) -> str:
        result = ["    <property>", "        <name>%s</name>" % node.name,
                  "        <value>%s</value>" % node.value]
        if node.description:
            result.append("        <description>%s</description>" % node.description)
        result.append("    </property>")
        return "\n".join(result)


class ConfigNodePropertiesRenderer(ConfigNodeRenderer):

    def _render_config_data(self, node: ConfigDataNode):
        description = self._render_remark(node.description)
        if node.name.find("\n") > -1:
            raise Exception("Property name %s has newline." % node.name)
        if node.value.find("\n") > -1:
            raise Exception("Property value %s has newline." % node.value)
        result = "{description}{name}={value}".format(
            description=description,
            name=node.name,
            value=node.value
        )
        return result

    def _render_remark(self, description: str) -> str:
        if description.find("\n") > -1:
            description_lines = description.split("\n")
            lines = []
            for line in description_lines:
                lines.append("# %s" % line)
            description = "\n".join(lines)
        elif description:
            description = "# %s\n" % description
        return description
