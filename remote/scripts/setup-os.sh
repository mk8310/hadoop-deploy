#!/usr/bin/env bash

HD_User=$1
HD_Group=$2

yum install -y lsof vim wget lrzsz tree zip unzip net-tools ntp curl git

rm -Rf /tmp/*

if [[ ! -d /opt/backup ]]; then
    mkdir /opt/backup
fi

if [[ ! -d /opt/cluster ]]; then
    mkdir /opt/cluster
fi

chown -R ${HD_User}:${HD_Group} /opt/cluster

if [[ ! -f /opt/backup/limits.conf ]]; then
    cp /etc/security/limits.conf /opt/backup/;
fi
if [[ ! -f /opt/backup/20-nproc.conf ]]; then
    cp /etc/security/limits.d/20-nproc.conf /opt/backup/;
fi
if [[ ! -f /opt/backup/login ]]; then
    cp /etc/pam.d/login /opt/backup/;
fi

cat /opt/remote/configs/sys-config/limits.conf > /etc/security/limits.conf
cat /opt/remote/configs/sys-config/20-nproc.conf > /etc/security/limits.d/20-nproc.conf
cat /opt/remote/configs/sys-config/login > /etc/pam.d/login
cat /opt/remote/configs/sys-config/profile.sh > /etc/profile.d/hd.sh

#
#while read line; do
#    if [[ `grep -c "${line}" /etc/profile` -eq '0' ]]; then
#        echo "${line}" >> /etc/profile;
#    fi
#done < /opt/remote/configs/sys-config/profile.sh
