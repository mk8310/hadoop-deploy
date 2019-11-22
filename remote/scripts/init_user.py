#!/usr/bin/env python
# -*-coding:utf-8-*-
"""
Author : Min
date   : 2019/11/4
"""
import crypt
import grp
import os
import argparse
import pwd
from ssh_keygen import generate_ssh_key


def exists_group(group_name):
    try:
        grp.getgrnam(group_name)
        return True
    except:
        return False


def exists_user(user_name):
    try:
        pwd.getpwnam(user_name)
        return True
    except:
        return False


def create_user():
    parser = argparse.ArgumentParser(description='App for create user.')
    parser.add_argument("--group")
    parser.add_argument("--username")
    parser.add_argument("--password")

    args = parser.parse_args()
    group = args.group
    username = args.username
    password = args.password
    enc_pass = crypt.crypt(password, "22")
    if exists_group(group):
        print("group %s exists." % group)
    else:
        cmd = "groupadd {groupname}".format(groupname=group)
        os.system(cmd)
        print("group {groupname} created.".format(groupname=group))
    if exists_user(username):
        print("user %s exists" % username)
        cmd = "usermod -a -G {groupname} {username}".format(groupname=group, username=username)
        os.system(cmd)
    else:
        cmd = "useradd -g {groupname} -p {password} -s /bin/bash -d /home/{username} -m {username}". \
            format(password=enc_pass, username=username, groupname=group)
        os.system(cmd)
        print("user {username} created.".format(username=username))
    generate_ssh_key(username)


if __name__ == '__main__':
    create_user()
