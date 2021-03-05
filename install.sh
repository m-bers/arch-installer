#!/bin/bash

USERNAME="[username]"
PASSWORD="[password]"
DISK="/dev/sda"

echo -e "g\nn\n\n\n+500M\nt\n1\nn\n\n\n\nt\n\n30\nw\n" | fdisk $DISK
mkfs.vfat -F32 "${DISK}1"
pvcreate --dataalignment 1m "${DISK}2"
vgreate vg0 "${DISK}2"
lvcreate -L 30GB vg0 -n root
lvcreate -L 50GB vg0 -n home
modprobe dm_mod
vgchange -ay
mkfs.ext4 /dev/vg0/root
mount /dev/vg0/root /mnt
mkdir /mnt/home
mount /dev/vg0/home /mnt/home
mkdir /mnt/etc
genfstab -U -p /mnt >> /mnt/etc/fstab
pacstrap /mnt base
