#!/bin/sh

P1=`dirname $0`
HOME=`cd $P1; cd .. ; pwd`

. $HOME/etc/env.conf

$HOME/$VENV/bin/python $HOME/$DIR/manage.py shell
