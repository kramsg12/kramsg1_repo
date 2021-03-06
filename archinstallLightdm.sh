#!/bin/bash
#WARNING the following packages are needed if installing on archiso:
#bash, curl, wget, dialog as script dependants.
# WARNING: this script will destroy data on the selected disk.
# This script can be run by executing the following:
#   curl -sL http://bit.ly/kramsg1arch | bash
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

### Get infomation from user ###
hostname=$(dialog --stdout --inputbox "Enter hostname" 0 0) || exit 1
clear
: ${hostname:?"hostname cannot be empty"}

user=$(dialog --stdout --inputbox "Enter admin username" 0 0) || exit 1
clear
: ${user:?"user cannot be empty"}

password=$(dialog --stdout --passwordbox "Enter admin password" 0 0) || exit 1
clear
: ${password:?"password cannot be empty"}
password2=$(dialog --stdout --passwordbox "Enter admin password again" 0 0) || exit 1
clear
[[ "$password" == "$password2" ]] || ( echo "Passwords did not match"; exit 1; )

devicelist=$(lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop" | tac)
device=$(dialog --stdout --menu "Select installation disk" 0 0 0 ${devicelist}) || exit 1
clear

### Set up logging ###
exec 1> >(tee "stdout.log")
exec 2> >(tee "stderr.log")

timedatectl set-ntp true

### Setup the disk and partitions ###
swap_size=$(free --mebi | awk '/Mem:/ {print $2}')
swap_end=$(( $swap_size + 129 + 1 ))MiB

parted --script "${device}" -- mklabel gpt \
  mkpart ESP fat32 1Mib 129MiB \
  set 1 boot on \
  mkpart primary linux-swap 129MiB ${swap_end} \
  mkpart primary ext4 ${swap_end} 100%

# Simple globbing was not enough as on one device I needed to match /dev/mmcblk0p1
# but not /dev/mmcblk0boot1 while being able to match /dev/sda1 on other devices.
part_boot="$(ls ${device}* | grep -E "^${device}p?1$")"
part_swap="$(ls ${device}* | grep -E "^${device}p?2$")"
part_root="$(ls ${device}* | grep -E "^${device}p?3$")"

wipefs "${part_boot}"
wipefs "${part_swap}"
wipefs "${part_root}"

mkfs.vfat -F32 "${part_boot}"
mkswap "${part_swap}"
mkfs.f2fs -f "${part_root}"

swapon "${part_swap}"
mount "${part_root}" /mnt
mkdir /mnt/boot
mount "${part_boot}" /mnt/boot

### Install and configure the basic system ###
wget https://raw.githubusercontent.com/kramsg12/kramsg1_repo/master/pacman.conf 
mv -f pacman.conf /etc/pacman.conf
pacman -Sy
pacstrap /mnt kramsg1-base lightdm terminator
genfstab -t PARTUUID /mnt >> /mnt/etc/fstab
echo "${hostname}" > /mnt/etc/hostname

wget https://raw.githubusercontent.com/kramsg12/kramsg1_repo/master/pacman.conf
mv -f pacman.conf /mnt/etc/pacman.conf


arch-chroot /mnt bootctl install

cat <<EOF > /mnt/boot/loader/loader.conf
default arch
EOF

cat <<EOF > /mnt/boot/loader/entries/arch.conf
title    Arch Linux
linux    /vmlinuz-linux
initrd   /initramfs-linux.img
options  root=PARTUUID=$(blkid -s PARTUUID -o value "$part_root") rw
EOF

echo "LANG=en_GB.UTF-8" > /mnt/etc/locale.conf
arch-chroot /mnt pacman -S --noconfirm broadcom-wl sudo

wget https://raw.githubusercontent.com/kramsg12/kramsg1_repo/master/sudoers
arch-chroot /mnt useradd -mU -s /usr/bin/zsh -G wheel,uucp,video,audio,storage,root,games,input "$user"
mv -f sudoers /mnt/etc/sudoers
arch-chroot /mnt chsh -s /usr/bin/zsh
arch-chroot /mnt pacman -S --noconfirm networkmanager
arch-chroot /mnt systemctl enable NetworkManager.service
arch-chroot /mnt pacman -S --noconfirm kramsg1-cinnimon
arch-chroot /mnt pacman -S --noconfirm lightdm-gtk-greeter
arch-chroot /mnt pacman -S --noconfirm curl
arch-chroot /mnt pacman -S --noconfirm wget
arch-chroot /mnt systemctl enable lightdm.service
arch-chroot /mnt systemctl start lightdm.service

#arch-chroot /mnt pacman -S --noconfirm broadcom-wl gksu sudo
echo "$user:$password" | chpasswd --root /mnt
echo "root:$password" | chpasswd --root /mnt
echo ' '
echo 'install finished Pc will reboot '
sleep 5
reboot
