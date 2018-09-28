#!/bin/sh

P1=`dirname $0`
HOME=`cd $P1; cd .. ; pwd`

. $HOME/etc/env.conf

# PORT=`cat $HOME/etc/devport`
# pids=`ps ax|grep $PORT|grep -vi grep|sed -e s/'^  '//|sed -e s/'^ '//|cut -d' ' -f1`
# for i in $pids;do kill $i;done

$HOME/$VENV/bin/python $HOME/$DIR/manage.py migrate
