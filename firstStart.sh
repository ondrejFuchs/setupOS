#!/bin/bash  
###
# Script for setup Raspbian before first start.
#

# Wi-Fi and SSH configuration
cp wpa_supplicant.conf /media/pc/boot/
cp ssh /media/pc/boot/
#ID1="c7cb7e34"
SUBSTRING=$(sudo fdisk -l /dev/sdc | grep '^Disk identifier:')
stringarray=($SUBSTRING)
ID1=${stringarray[2]:2}
# Set partition
lsblk
read -e -p "Set partition (sda, sdb, sdc ect.): " -i "sdc" part
echo "/dev/"$part
# Resize rootfs partition 
sudo parted -m /dev/$part print free
read -e -p "Set end: " -i "4000" end
sudo parted -m /dev/$part resizepart 2 Yes $end"MB"
sudo resize2fs /dev/$part"2" $end"M"

# Make new partition with XFS file system
sudo parted -m /dev/sdc print free
read -e -p "Set start (MB): " -i "4001" start
read -e -p "Set end (GB): " -i "15,6" end
sudo parted -m /dev/sdc mkpart primary $start"MB" $end"GB"
sudo mkfs.xfs  /dev/sdc3
SUBSTRING=$(sudo fdisk -l /dev/sdc | grep '^Disk identifier:')
stringarray=($SUBSTRING)
ID2=${stringarray[2]:2}
# After changes we must edit cmdline.txt and fstab
sed -i -e 's/'"$ID1"'/'"$ID2"'/g' /media/pc/boot/cmdline.txt
sed -i -e 's/'"$ID1"'/'"$ID2"'/g' /media/pc/rootfs/etc/fstab
# Disable auto resize of partition after first boot
input="/media/pc/boot/cmdline.txt"
one="init=/usr/lib/raspi-config/init_resize.sh"
two="quiet"
while read line 
do 
  line=$(printf '%s\n' "${line//$one/}")
  line=$(printf '%s\n' "${line//$two/}")
  echo $line > /media/pc/boot/cmdline.txt
done <$input 
# Mount new partition to /mnt/xfsdata
SUBSTRING=$(blkid /dev/sdc3)
stringarray=($SUBSTRING)
one=${stringarray[1]:5}
UUID=$(echo "${one//\"}")
echo "UUID=$UUID"  "/mnt/xfsdata/ xfs defaults 0 0" >> /media/pc/rootfs/etc/fstab
mkdir /media/pc/rootfs/mnt/xfsdata
# Dataplicity
#sudo cp mass-install-dp /media/pc/rootfs/etc/network/if-up.d/
#sudo chmod 755 /media/pc/rootfs/etc/network/if-up.d/mass-install-dp




