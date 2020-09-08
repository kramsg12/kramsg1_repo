#!/bin/bash

# updateing the main system
pacman -Syu --noconfirm

# installing base development tools and git
pacman -S --noconfirm git base-devel go

# installing AUR support
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd

# steam and lutris
pacman -S --noconfirm steam lutris

# installing nvidia drivers
pacman -S --noconfirm nvidia vulkan-icd-loader






