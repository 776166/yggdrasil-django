#!/bin/sh

APPLICATION=$DIR/$APP
P1=`dirname $0`
HOME=`cd $P1; cd .. ; pwd`

if [ -d $HOME/bin/dist ]; then
    rm -v $HOME/bin/dist/*
else
    mkdir $HOME/bin/dist
fi

for script in `cat $HOME/bin/dist.conf`; do
    ln -svf -t ./dist $script ../$script
done