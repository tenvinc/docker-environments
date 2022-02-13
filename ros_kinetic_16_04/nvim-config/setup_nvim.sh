#!/bin/bash

PWD=$(pwd)
# Remove existing neovim
sudo apt-get remove neovim

sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install -y neovim

# Transfer all the configurations
mkdir -p ~/.config
cp -r tmp/nvim-config/config/ ~/.config/nvim/
