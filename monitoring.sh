#!/bin/bash

# ARCH
arch=$(uname -a)

# CPU PHYSICAL
cpuf=$(grep "physical id" /proc/cpuinfo | sort -u | wc -l)

# CPU VIRTUAL
cpuv=$(grep "physical id" /proc/cpuinfo | wc -l)

# RAM
ram_total=$(free --mega | awk 'NR==2{print $2}')
ram_use=$(free --mega | awk 'NR==2{print $3}')
ram_percent=$(free --mega | awk 'NR==2{printf("(%.2f%%)\n", $3/$2*100)}')

# DISK
disk_total=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_t += $2} END {printf ("%.1fGb\n"), disk_t/1024}')
disk_use=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} END {print disk_u}')
disk_percent=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} {disk_t+= $2} END {printf("%d"), disk_u/disk_t*100}')

# CPU LOAD
cpu_fin=$(grep 'cpu ' /proc/stat | awk '{usage=($2 + $3 + $4)*100/($2 + $3 + $4 + $5)} END {printf("%d/%d, %.2f%%\n", ($2 + $3 + $4), ($2 + $3 + $4 + $5), usage)}')

# LAST BOOT
lb=$(who -b | awk '{print $3 " " $4}')

# LVM USE
lvmu=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no; fi)

# TCP CONNEXIONS
tcpc=$(ss -ta | grep ESTAB | wc -l)

# USER LOG
ulog=$(uptime | awk '{print $5}')

# NETWORK
ip=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{print $2}')

# SUDO
cmnd=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "	Architecture: $arch
	CPU physical: $cpuf
	vCPU: $cpuv
	Memory Usage: $ram_use/${ram_total}MB $ram_percent
	Disk Usage: $disk_use/${disk_total} ($disk_percent%)
	CPU load: $cpu_fin
	Last boot: $lb
	LVM use: $lvmu
	Connections TCP: $tcpc ESTABLISHED
	User log: $ulog
	Network: IP $ip ($mac)
	Sudo: $cmnd cmd"
