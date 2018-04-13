#!/bin/bash  
# Script for setup Raspbian to connect by SSH
cp /home/pc/Dropbox/DP/konfigurace/wifi/wpa_supplicant.conf /media/pc/rootfs/etc/wpa_supplicant/
cp /home/pc/Dropbox/DP/konfigurace/wifi/wpa_supplicant.conf /media/pc/boot/
cat <<EOT > /media/pc/rootfs/etc/rc.local
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

# Print the IP address
_IP=\$(hostname -I) || true
if [ "\$_IP" ]; then
  printf "My IP address is %s\n" "\$_IP"
fi

sudo systemctl enable ssh
sudo systemctl start ssh
exit 0
EOT
# Tohle pomocí ansible
#mkdir /media/pc/rootfs/home/pi/.ssh/
#cp /home/pc/Dropbox/DP/konfigurace/wifi/authorized_keys /media/pc/rootfs/home/pi/.ssh/
#chmod 700 /media/pc/rootfs/home/pi/.ssh/
#chmod 600 /media/pc/rootfs/home/pi/.ssh/authorized_keys


