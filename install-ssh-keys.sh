#!/usr/bin/env bash

# machine list
HostList=`cat ./configs/all-servers.lst`
# port
Port=22
RootName="root"
RootPassword="sz0ByxjoYeTh"
UserName="hduser"
GroupName="hdgroup"
UserPassword="sz0ByxjoYeTh"

function pause(){
        read -n 1 -p "$*" INP
        if [[ ${INP} != '' ]] ; then
                echo -ne '\b \n'
        fi
}

# Generate ssh key for local machine.
echo -e "\033[34m 1. Generate ssh key for local machine. \033[0m"
if [[ ! -f ~/.ssh/id_rsa && -f ~/.ssh/id_rsa.pub ]]; then
    rm -Rf ~/.ssh/
    ssh-keygen -f ~/.ssh/id_rsa -t rsa -b 4096 -N ''
elif [[ ! -f ~/.ssh/id_rsa.pub && -f ~/.ssh/id_rsa ]]; then
    rm -Rf ~/.ssh/
    ssh-keygen -f ~/.ssh/id_rsa -t rsa -b 4096 -N ''
elif [[ ! -f ~/.ssh/id_rsa.pub && ! -f ~/.ssh/id_rsa ]]; then
    ssh-keygen -f ~/.ssh/id_rsa -t rsa -b 4096 -N ''
fi
cat ~/.ssh/id_rsa.pub > authorized_keys

# Send install scripts to remote machine.
echo -e "\033[34m 2. Send install scripts to remote machine. \033[0m"
for Host in ${HostList}
do
    expect ./send-directory.exp ${Host} ${Port} ${RootName} ${RootPassword} "./remote" "/opt/"
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m Send install scripts to $Host success. \033[0m"
    else
        echo -e "\033[31m Send install scripts to $Host failure. \033[0m"
        exit
    fi
done

#pause 'Press any key to continue...'

# Generate root user ssh key for remote machine.
for Host in ${HostList}
do
    echo -e "\033[34m 3. Generate root user ssh key for ${Host} \033[0m"
#    expect ./ssh-keygen.exp ${Host} ${Port} ${RootName} ${RootPassword}
    python3 ./exec_remote_command.py --host=${Host} --port=${Port} --user=${RootName} --password=${RootPassword} --cmd="python /opt/remote/scripts/ssh_keygen.py --username=${RootName}"
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m Host $Host for user $RootName rsa generate success. \033[0m"
    else
        echo -e "\033[31m Host $Host for user $RootName rsa generate failure. \033[0m"
        exit
    fi

#    pause 'Press any key to continue...'


    echo -e "\033[34m 4. Send root authorized_keys to ${Host} \033[0m"
    expect ./send-file.exp ${Host} ${Port} ${RootName} ${RootPassword} "./authorized_keys" "~/.ssh/"
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m Send root's authorized_keys to $Host success. \033[0m"
    else
        echo -e "\033[31m Send root's authorized_keys to $Host failure. \033[0m"
        exit
    fi

#    pause 'Press any key to continue...'

    echo -e "\033[34m 5. Create user ${UserName} on ${Host} \033[0m"
    ssh -p ${Port} ${RootName}@${Host} "python /opt/remote/scripts/init_user.py --group=${GroupName} --username=${UserName} --password=${UserPassword}"
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m Create user $UserName on $Host success. \033[0m"
    else
        echo -e "\033[31m Create user $UserName on $Host failure. \033[0m"
        exit
    fi

#    pause 'Press any key to continue...'

    echo -e "\033[34m 6. Send ${UserName} authorized_keys to ${Host} \033[0m"
    expect ./send-file.exp ${Host} ${Port} ${UserName} ${UserPassword} "./authorized_keys" "~/.ssh/"
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m Send $UserName 's authorized_keys to $Host success. \033[0m"
    else
        echo -e "\033[31m Send $UserName 's authorized_keys to $Host failure. \033[0m"
        exit
    fi

    echo -e "\033[34m 7. Export ${UserName} public rsa on ${Host} to authorized_keys \033[0m"
    ssh -p ${Port} ${UserName}@${Host} "cat ~/.ssh/id_rsa.pub" >> authorized_keys
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m Host $Host public rsa export success. \033[0m"
    else
        echo -e "\033[31m Host $Host public rsa export failure. \033[0m"
        exit
    fi

    for DestHost in ${HostList}
    do
        echo -e "\033[34m 8. Generate $Host about $DestHost known_hosts. \033[0m"
        ssh "$UserName@$Host" "ssh-keyscan -H $DestHost >> ~/.ssh/known_hosts"
        if [[ $? -eq 0 ]];then
            echo -e "\033[32m $Host about $DestHost known_hosts generate success. \033[0m"
        else
            echo -e "\033[31m $Host about $DestHost known_hosts generate failure. \033[0m"
            exit
        fi
    done
done

for Host in ${HostList}
do
    echo -e "\033[34m 9. Send $UserName 's authorized_keys to $Host. \033[0m"
    scp -P ${Port}  ./authorized_keys ${UserName}@${Host}:~/.ssh/
    if [[ $? -eq 0 ]];then
        echo -e "\033[32m Send $UserName 's authorized_keys to $Host success. \033[0m"
    else
        echo -e "\033[31m Send $UserName 's authorized_keys to $Host failure. \033[0m"
        exit
    fi
done
