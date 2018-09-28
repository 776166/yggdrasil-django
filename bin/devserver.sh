#!/bin/sh

P1=`dirname $0`
HOME=`cd $P1; cd .. ; pwd`
CORRECT_UNIX_USER=`echo $HOME | cut -d'/' -f3`
ME=`whoami`

if [ $ME != $CORRECT_UNIX_USER ]; then
 echo 'Please run "'${0##*/}'" script ONLY under "'$CORRECT_UNIX_USER'" user. Not under "'$ME'" user.'
 exit
fi

. $HOME/etc/env.conf

pids=`ps ax|grep $DEV_PORT|grep -vi grep|sed -e s/'^  '//|sed -e s/'^ '//|cut -d' ' -f1`
for i in $pids;do kill $i;done

$HOME/$VENV/bin/python -O $HOME/$DIR/manage.py runserver 127.0.0.1:$DEV_PORT
