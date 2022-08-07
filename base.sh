#!/bin/sh


### Basic configuration

# Setting up time
ln -sf /usr/share/zoneinfo/Europe/Bucharest /etc/localtime
hwclock --systohc

# Generating locale
sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# Configuring hostname
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts


### Package installation

# Some base packages (replace intel-ucode with amd-ucode if needed)
pacman -Syu --needed intel-ucode base-devel git xdg-user-dirs

# Text editor (please don't kill me vim users)
pacman -S --needed micro

# Networking (networkmanager, firewalld with nftables, openssh)
pacman -S --needed networkmanager
systemctl enable NetworkManager
pacman -S --needed nftables iptables-nft firewalld ipset
systemctl enable firewalld
pacman -S --needed openssh
systemctl enable sshd

# Sound (pipewire)
pacman -S --needed sof-firmware 
pacman -S --needed alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack

# Bluetooth (bluez) 
pacman -S --needed bluez bluez-utils
systemctl enable bluetooth

# Printing (cups)
pacman -S --needed cups
systemctl enable cups

# Bootloader (refind)
pacman -S --needed refind 
refind-install

# NTFS file system support
pacman -S --needed ntfs-3g

# SSD weekly TRIM using fstrim.timer
pacman -S --needed util-linux
systemctl enable fstrim.timer

# GPU drivers (nvidia proprietary)
pacman -S --needed nvidia nvidia-utils nvidia-settings nvidia-prime

# User & passwords
pacman -S --needed sudo
echo root:password | chpasswd
useradd -m user
echo user:password | chpasswd
echo "user ALL=(ALL:ALL) ALL" >> /etc/sudoers


### Some very specific personal fixes and tweaks

# Fixing internal audio for Asus G512-LV
printf "options snd_hda_intel model=asus-zenbook" > /etc/modprobe.d/alsa-base.conf

# Makepkg parallel compilation (on all threads)
echo "MAKEFLAGS=\"-j\$(nproc)\"" >> /etc/makepkg.conf

# Important reminders (if using btrfs)
# - change refind config files for compatibility with btrfs
# - add 'btrfs' module in /etc/mkinitcpio.conf and regen image with 'mkinitcpio -p linux'






