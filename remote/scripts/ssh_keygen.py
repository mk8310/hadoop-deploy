#!/usr/bin/env python
# -*-coding:utf-8-*-
"""
Author : Min
date   : 2019/11/5
"""
import argparse
import os


def get_ssh_path(username):
    if username.lower() == "root":
        return "/root/.ssh"
    return "/home/{username}/.ssh".format(username=username)


def gen_ssh_key():
    parser = argparse.ArgumentParser(description='App for generate ssh keys.')
    parser.add_argument("--username")

    args = parser.parse_args()
    username = args.username
    generate_ssh_key(username)


def generate_ssh_key(username):
    ssh_path = get_ssh_path(username)
    private_rsa_file = os.path.join(ssh_path, "id_rsa")
    public_rsa_file = os.path.join(ssh_path, "id_rsa.pub")
    if not (os.path.exists(private_rsa_file) and os.path.exists(public_rsa_file)):
        cmd = """su {username} -c "ssh-keygen -f ~/.ssh/id_rsa -t rsa -b 4096 -N ''" """.format(username=username)
        os.system(cmd)
    elif not os.path.exists(private_rsa_file) and os.path.exists(public_rsa_file):
        os.removedirs(ssh_path)
        cmd = """su {username} -c "ssh-keygen -f ~/.ssh/id_rsa -t rsa -b 4096 -N ''" """.format(username=username)
        os.system(cmd)
    elif os.path.exists(private_rsa_file) and not os.path.exists(public_rsa_file):
        os.removedirs(ssh_path)
        cmd = """su {username} -c "ssh-keygen -f ~/.ssh/id_rsa -t rsa -b 4096 -N ''" """.format(username=username)
        os.system(cmd)


if __name__ == '__main__':
    gen_ssh_key()
