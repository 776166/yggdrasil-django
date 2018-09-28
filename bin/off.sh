#!/bin/sh

P1=`dirname $0`
HOME=`cd $P1; cd .. ; pwd`

. $HOME/etc/env.conf

name=`echo $HOME|cut -d'/' -f4`
version=`echo $HOME|cut -d'/' -f5`
file=$alive_dir$name'-'$version'-ui'

if [ -e $file ]; then
    chmod u+w $file
    rm -v $file
fi

echo `date +%Y%m%d-%H%M`' '$name' '$version' off' >> $alive_log 2>&1

file=$uwsgi_dir$name'-'$version'-ui.yaml'

if [ -e $file ]; then
    chmod u+w $file
    rm -v $file
fi

echo `date +%Y%m%d-%H%M`' '$name' '$version' off' >> $uwsgi_log 2>&1