#!/bin/sh

APPLICATION=$DIR/$APP
P1=`dirname $0`
HOME=`cd $P1; cd .. ; pwd`

. $HOME/etc/env.conf

if [ -d $HOME/$DIR/$STATIC_DIST ]; then rm -r $HOME/$DIR/$STATIC_DIST; fi
if [ -d $HOME/dist ]; then rm -r $HOME/dist; fi
