#!/usr/bin/env python
# -*-coding:utf-8-*-
"""
Author : Min
date   : 2019/11/21
"""
from enum import Enum
from typing import List


class OutputType(Enum):
    xml = 0
    properties = 1


class ConfigNode(object):
    pass


class ConfigRemarkNode(ConfigNode):
    def __init__(self, **kwargs):
        self.description = "" if "description" not in kwargs else kwargs["description"]


class ConfigDataNode(ConfigNode):
    def __init__(self, **kwargs):
        self.name = "" if "name" not in kwargs else kwargs["name"]
        self.value = "" if "value" not in kwargs else kwargs["value"]
        self.description = "" if "description" not in kwargs else kwargs["description"]
        self.output_type = OutputType.xml if "output" not in kwargs else kwargs["output"]

    def __str__(self):
        if self.output_type == OutputType.properties:
            return self.return_properties()
        return self.return_xml()

    def return_xml(self):
        result = ["    <property>", "        <name>%s</name>" % self.name, "        <value>%s</value>" % self.value]
        if self.description:
            result.append("        <description>%s</description>" % self.description)
        result.append("    </property>")
        return "\n".join(result)

    def return_properties(self):
        description = self.description
        if self.description.find("\n") > -1:
            description_lines = self.description.split("\n")
            lines = []
            for line in description_lines:
                lines.append("# " % line)
            description = "\n".join(lines)
        elif self.description:
            description = "# %s\n" % self.description

        if self.name.find("\n") > -1:
            raise Exception("Property name %s has newline." % self.name)

        if self.value.find("\n") > -1:
            raise Exception("Property value %s has newline." % self.value)

        result = "{description}{name}={value}".format(
            description=description,
            name=self.name,
            value=self.value
        )
        return result


class Configuration(List[ConfigNode]):
    def __init__(self, **kwargs):
        self.output_type = OutputType.xml if "output" not in kwargs else kwargs["output"]
        super(Configuration, self).__init__()

    def add_data_config(self, name, value, description=""):
        for config_node in self:
            if isinstance(config_node, ConfigDataNode):
                if config_node.name.lower() == name.lower():
                    raise Exception("Property name %s exists." % name)
        config_node = ConfigDataNode(
            name=name,
            value=value,
            description=description,
            output=self.output_type
        )
        self.append(config_node)

    def update_data_config(self, name, value, description=""):
        node = None
        for config_node in self:
            if isinstance(config_node, ConfigDataNode):
                if config_node.name.lower() == name.lower():
                    node = config_node
                    break

        if node:
            # raise Exception("Property name %s not exists." % name)
            node.name = name
            node.value = value
            node.description = description
        else:
            self.add_data_config(name, value, description)

    def add_remark_config(self, description: str):
        description = description.strip("#")
        config_node = ConfigRemarkNode(description=description)
        self.append(config_node)

    def __str__(self):
        result = []
        if self.output_type == OutputType.xml:
            result.append("<configuration>")
        for config_property in self:
            result.append(str(config_property))
        if self.output_type == OutputType.xml:
            result.append("</configuration>")
        return "\n".join(result)
