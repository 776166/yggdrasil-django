#!/bin/sh

APPLICATION=$DIR/$APP
P1=`dirname $0`
HOME=`cd $P1; cd .. ; pwd`

. $HOME/etc/env.conf

pyformat -r -i -j `nproc` --exclude "pip-requirements.txt" $HOME/site/*