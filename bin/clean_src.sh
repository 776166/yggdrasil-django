#!/bin/sh

APPLICATION=$DIR/$APP
P1=`dirname $0`
HOME=`cd $P1; cd .. ; pwd`

. $HOME/etc/env.conf

for i in $css; do
    if [ -f $HOME/$DIR/static-dev/css/$i.min.css ]; then rm $HOME/$DIR/static-dev/css/$i.min.css; fi
done

for i in $js; do
    if [ -f $HOME/$DIR/static-dev/js/$i.min.js ]; then rm $HOME/$DIR/static-dev/js/$i.min.js; fi
done
