#!/bin/bash

if [ "X$TEMPDIR"=="X" ]; then
    TEMPDIR=/tmp
fi

suckless_dir=$(pwd)/suckless

for p in $(find $suckless_dir -mindepth 1 -maxdepth 1 -type d); do

    echo "Installing $p"

    cd $p

    make
    sudo make install

done
