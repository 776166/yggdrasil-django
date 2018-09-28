#!/bin/sh

APPLICATION=$DIR/$APP
P1=`dirname $0`
HOME=`cd $P1; cd .. ; pwd`

. $HOME/etc/env.conf

if [ ! -z $1 ]; then
    clean_path=$HOME/$1
else
    clean_path=$HOME
fi

find $clean_path -type d -name '__pycache__' -print | xargs rm -vr
find $clean_path -name '*.pyc' -print -delete
find $clean_path -name '*.pyo' -print -delete
