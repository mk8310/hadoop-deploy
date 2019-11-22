#!/usr/bin/env python
# -*-coding:utf-8-*-
"""
Author : Min
date   : 2019/11/14
"""
import argparse
import paramiko


def exec_cmd():
    parser = argparse.ArgumentParser(description='App for create user.')
    parser.add_argument("--host")
    parser.add_argument("--port")
    parser.add_argument("--user")
    parser.add_argument("--password")
    parser.add_argument("--cmd")
    args = parser.parse_args()
    cmd = args.cmd
    host = args.host
    port = args.port
    user = args.user
    password = args.password

    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(host, port, user, password)
    try:
        stdin, stdout, stderr = ssh.exec_command(cmd)
        result = stdout.readlines()
        result = [item.strip("\n") for item in result]
        print("\n".join(result))
    finally:
        ssh.close()


if __name__ == '__main__':
    exec_cmd()
