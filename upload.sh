#!/usr/bin/env bash

# machine list
HostList=`cat ./configs/all-servers.lst`
Port=22
RootName="root"
RootPassword="sz0ByxjoYeTh"
UserName="hduser"
GroupName="hdgroup"
UserPassword="sz0ByxjoYeTh"
UploadType=$1

SourcePath="./remote/scripts"
DestPath="/opt/remote/"

if [[ ${UploadType} = "all" ]]; then
    SourcePath="./remote/"
    DestPath="/opt/"
elif [[ ${UploadType} = "servers" ]]; then
    SourcePath="./remote/servers"
    DestPath="/opt/remote/"
elif [[ ${UploadType} = "packages" ]]; then
    SourcePath="./remote/packages"
    DestPath="/opt/remote/"
elif [[ ${UploadType} = "scripts" ]]; then
    SourcePath="./remote/scripts"
    DestPath="/opt/remote/"
elif [[ ${UploadType} = "configs" ]]; then
    SourcePath="./remote/configs"
    DestPath="/opt/remote/"
fi

echo -e "\033[34m Send directory to remote machine. \033[0m"
for Host in ${HostList}
do
    scp -r -P ${Port} ${SourcePath} ${RootName}@${Host}:${DestPath}
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m Send install scripts to $Host success. \033[0m"
    else
        echo -e "\033[31m Send install scripts to $Host failure. \033[0m"
        exit
    fi
done