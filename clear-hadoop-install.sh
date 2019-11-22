#!/usr/bin/env bash

HostList=`cat ./configs/all-servers.lst`

for Host in ${HostList}
do
    ssh root@${Host} "rm -Rf /opt/cluster; rm -Rf /opt/remote"
    ssh root@${Host} "userdel -r hduser; groupdel hdgroup;"
    ssh root@${Host} "hostnamectl set-hostname ${Host}"
    ssh root@${Host} "rm -Rf ~/.ssh"
done
