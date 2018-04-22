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
# Make new partition with XFS file system
sudo parted -m /dev/sdc print free
echo "Start (MB)?"
read start
echo "End (GB)?"
read end
echo $start"MB" $end"GB"
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















#cat <<EOT > /media/pc/rootfs/etc/rc.local
#!/bin/sh -e

 #rc.local

 #This script is executed at the end of each multiuser runlevel.
 #Make sure that the script will "exit 0" on success or any other
 #value on error.

 #In order to enable or disable this script just change the execution
 #bits.

 #By default this script does nothing.

 #Print the IP address
#_IP=\$(hostname -I) || true
#if [ "\$_IP" ]; then
  #printf "My IP address is %s\n" "\$_IP"
#fi

#sudo systemctl enable ssh
#sudo systemctl start ssh
#exit 0
#EOT
# Tohle pomocí ansible
#mkdir /media/pc/rootfs/home/pi/.ssh/
#cp /home/pc/Dropbox/DP/konfigurace/wifi/authorized_keys /media/pc/rootfs/home/pi/.ssh/
#chmod 700 /media/pc/rootfs/home/pi/.ssh/
#chmod 600 /media/pc/rootfs/home/pi/.ssh/authorized_keys


