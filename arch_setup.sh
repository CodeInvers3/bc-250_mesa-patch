#!/usr/bin/env bash

echo "Installing Mesa 3D patched"
cd mesa-git
updpkgsums
makepkg -si

# RADV_DEBUG
echo "set mode RADV DEBUG"
echo 'RADV_DEBUG=nocompute' | sudo tee /etc/environment

# oberon-governor
echo "Install oberon governor"
sudo pacman -S --needed cmake git base-devel libdrm
git clone https://gitlab.com/mothenjoyer69/oberon-governor.git
cd oberon-governor
cmake .
make
sudo make install
sudo cp oberon-governor.service /etc/systemd/system/
sudo systemctl enable --now oberon-governor.service

# Kernel mods
echo "Set kernel mods"
echo 'options amdgpu sg_display=0' | sudo tee /etc/modprobe.d/options-amdgpu.conf
echo 'nct6683' | sudo tee /etc/modules-load.d/99-sensors.conf
echo 'options nct6683 force=true' | sudo tee /etc/modprobe.d/options-sensors.conf
sudo mkinitcpio -P

# GRUB fix
sudo sed -i 's/nomodeset//g' /etc/default/grub
sudo sed -i 's/amdgpu\.sg_display=0//g' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "Needed to restart"
sudo reboot
