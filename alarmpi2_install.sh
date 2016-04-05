#### ALARMpi SD CARD INSTALL SCRIPT ####
#### 		@author : revosftw		####
#### 			23- Jul - 2015 		####

#!/bin/bash

#### VARIABLES ####
device="/dev/sdd"
partitions=($(lsblk "$device" | fgrep '─' | sed -E 's/^.+─(\w+).+$/\1/g'))
###################
sudo umount "/dev/${partitions[0]}"
sudo umount "/dev/${partitions[1]}"
(echo o; echo n; echo p;echo 1; echo ; echo +100M; echo t; echo c; echo n; echo p; echo 2; echo ; echo ;echo w)|sudo fdisk $device
sudo fdisk -l $device
sudo mkfs.vfat -n "arm_boot" "/dev/${partitions[0]}"
mkdir boot
sudo mount "/dev/${partitions[0]}" boot
sudo mkfs.ext4 -L "arm_root" "/dev/${partitions[1]}"
mkdir root
sudo mount "/dev/${partitions[1]}" root
if ls|grep -qs 'ArchLinuxARM-rpi-2'; then
	echo "Using old copy of ArchLinuxARM"
else
	wget -q --show-progress -c http://archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz
fi
sudo su -c 'bsdtar -xvpf ArchLinuxARM-rpi-2-latest.tar.gz -C root'
sudo su -c 'sync'
sudo mv root/boot/* boot 
sudo umount boot root
sudo su -c "rm -rf boot root"
echo "SD CARD READY with ArchLinuxARM"