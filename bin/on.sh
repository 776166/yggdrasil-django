#!/bin/sh

P1=`dirname $0`
HOME=`cd $P1; cd .. ; pwd`

. $HOME/etc/env.conf

name=`echo $HOME|cut -d'/' -f4`
version=`echo $HOME|cut -d'/' -f5`
file=$alive_dir$name'-'$version'-ui'

if [ ! -e $file ]; then
    echo $HOME/ > $file
fi

chmod a-w $file

echo `date +%Y%m%d-%H%M`' '$name' '$version' on' >> $alive_log 2>&1

file=$uwsgi_dir$name'-'$version'-ui.yaml'

if [ ! -e $file ]; then
    ln -s $HOME/etc/uwsgi.yaml $file
fi
chmod a-w $file
echo `date +%Y%m%d-%H%M`' '$name' '$version' on' >> $uwsgi_log 2>&1
