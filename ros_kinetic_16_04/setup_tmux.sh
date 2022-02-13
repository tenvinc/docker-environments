#!/bin/bash

sudo apt install libssl-dev libevent-dev libncurses5-dev -y

###################### Not used in ubuntu 16.04 ####################################################
# cd $HOME
# wget https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz
# tar zxvf libevent-2.1.12-stable.tar.gz
# cd libevent-2.1.12-stable
# mkdir -p $HOME/local/libevent
# # install libevent under $HOME/local
# ./configure --prefix="$HOME/local/libevent" --enable-shared
# make -j && make install

# cd $HOME
# wget https://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.0.tar.gz
# tar zxvf ncurses-5.0.tar.gz
# cd ncurses-5.0/
# mkdir -p $HOME/local/ncurses
# ./configure --prefix="$HOME/local/ncurses" --with-shared --with-termlib --enable-pc-files --with-pkg-config-libdir=$HOME/local/ncurses/lib/pkgconfig
# make -j && make install
# make clean && make -j && make install
###################### Not used in ubuntu 16.04 ####################################################

cd $HOME
wget https://github.com/tmux/tmux/releases/download/2.9/tmux-2.9.tar.gz
tar zxvf tmux-2.9.tar.gz
cd tmux-2.9
mkdir -p $HOME/local/tmux
PKG_CONFIG_PATH=$HOME/local/ncurses/lib/pkgconfig:$HOME/local/libevent/lib/pkgconfig ./configure --prefix=$HOME/local/tmux 
make -j && make install

cd $HOME
export PATH=$HOME/local/tmux/bin:$PATH
git clone https://github.com/samoshkin/tmux-config.git
cd tmux-config
./install.sh