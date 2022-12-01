# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    script.sh                                          :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: afadlane <afadlane@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/12/01 13:01:38 by afadlane          #+#    #+#              #
#    Updated: 2022/12/01 13:01:44 by afadlane         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #


#!/bin/bash
arc=$(uname -a)
pcpu=$(nproc)
vcpu=$(cat /proc/cpuinfo | grep processor | wc -l)

rused=$(free -m | grep Mem | awk '{print $3}')
rtotal=$(free -m | grep Mem | awk '{print $2}')
ram=$(echo "$rused $rtotal" | awk '{printf("%.2f", $2/$1)}')

U_disk=$(df -Bm | grep "^/dev/" | awk '{print $3}'| grep -o [0-9]* | awk '{sum+=$1} END {print sum}')
T_disk=$(df -Bm | grep "^/dev/" | awk '{print $2}'| grep -o [0-9]* | awk '{sum+=$1} END {print sum}')
T_diskGO=$(df -Bg | grep "^/dev/" | awk '{print $2}'| grep -o [0-9]* | awk '{sum+=$1} END {print sum}')
disk=$(echo "$U_disk $T_disk" | awk '{printf("%.2f\n",$2/$1)}')

cpul=$(top -bn1 | grep "%Cpu" | awk '{printf("%.2f",$2+$4)}')
lb=$(who -b | awk '{print $3 " " $4}')
lvmt=$(lsblk | grep "lvm" | wc -l)
lvmu=$(if [ $lvmt -eq 0 ]; then echo no; else echo yes; fi)
ctcp=$(cat /proc/net/sockstat | grep TCP | awk '{print $3}')
ulog=$(users | wc -l)
ip=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{print $2}')
cmds=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
wall "  #Architecture: $arc
        #CPU physical: $pcpu
        #vCPU: $vcpu
        #Memory Usage:${rused}/${rtotal}MB ($ram%)
          #Disk Usage: ${U_disk}/${T_diskGO}GB ($disk%)
        #CPU load: $cpul%
        #Last boot: $lb
        #LVM use: $lvmu
        #Connexions TCP: $ctcp ESTABLISHED
        #User log: $ulog
        #Network: IP $ip ($mac)
        #Sudo: $cmds cmd"
