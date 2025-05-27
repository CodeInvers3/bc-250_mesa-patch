#!/bin/sh

echo "Compile mesa-git for Arch"
cd mesa-git
updpkgsums
makepkg -si
