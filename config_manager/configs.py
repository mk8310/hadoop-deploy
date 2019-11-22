#!/usr/bin/env python
# -*-coding:utf-8-*-
"""
Author : Min
date   : 2019/11/21
"""
import os
from abc import ABC, abstractmethod

from config_manager.models import Configuration


class Singleton(type):
    """
    Singleton pattern
    """
    _instances = {}

    def __call__(cls, *args, **kwargs):
        if cls not in cls._instances:
            cls._instances[cls] = super(Singleton, cls).__call__(*args, **kwargs)
        return cls._instances[cls]


class ServerNodeConfig(object):
    __metaclass__ = Singleton

    def __init__(self):
        self.name_node_list = self.__get_server_list("name-nodes.lst")
        self.master_name_node = self.__get_server_list("master-name-node.lst")[0]
        self.hbase_master_node = self.__get_server_list("hbase-master.lst")[0]
        self.zookeeper_list = self.__get_server_list("zookeepers.lst")
        self.journal_node_list = self.__get_server_list("journal-nodes.lst")
        self.resource_manager_list = self.__get_server_list("rm-nodes.lst")
        # self.node_manager_list = self.__get_server_list("node-managers.lst")
        self.data_node_list = self.__get_server_list("data-nodes.lst")
        self.hive_node_list = self.__get_server_list("hives.lst")
        self.hbase_master_list = self.__get_server_list("hbase-masters.lst")
        self.hbase_region_list = self.__get_server_list("hbase-regions.lst")
        self.atlas_node_list = self.__get_server_list("atlas-nodes.lst")

        self.hdfs_namespace = "ns1"
        self.hadoop_home = "/opt/cluster/hadoop"
        self.hive_home = "/opt/cluster/hive"
        self.name_node_names = []
        for index in range(len(self.name_node_list)):
            self.name_node_names.append("nn%d" % (index + 1))
        self.os_user = "hduser"
        self.rm_cluster_name = "rm-cluster"
        self.rm_node_names = []
        for index in range(len(self.resource_manager_list)):
            self.rm_node_names.append("rm%d" % (index + 1))
        self.hive_metadb_host = "mysql-dbhost"
        self.hive_metadb_port = 3306
        self.hive_metadb_user = "mysql-dbuser"
        self.hive_metadb_password = "mysql-dbpassword"
        self.hive_metadb_useSSL = False

    def get_zookeeper_server_list(self):
        zookeeper_server_list = [server + ":2181" for server in self.zookeeper_list]
        return zookeeper_server_list

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


class BaseConfig(object):
    __metaclass__ = ABC

    def __init__(self, cls):
        self._server_config = ServerNodeConfig()
        self._config = Configuration()
        self._renderer = cls(self._config)
        self._setup()

    @abstractmethod
    def _setup(self):
        pass

    def render(self):
        return self._renderer.render()
