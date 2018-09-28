#!/bin/sh

APPLICATION=$DIR/$APP
P1=`dirname $0`
HOME=`cd $P1; cd .. ; pwd`

if [ -d $HOME/bin/dist ]; then
    ls --color=never $HOME/bin/dist > $HOME/bin/dist.conf
else
    echo "No $HOME/bin/dist. Exiting."
    exit 1
fi