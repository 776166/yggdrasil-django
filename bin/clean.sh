#!/bin/sh

APPLICATION=$DIR/$APP
P1=`dirname $0`
HOME=`cd $P1; cd .. ; pwd`

. $HOME/etc/env.conf

$HOME/bin/clean_py.sh $DIR
$HOME/bin/clean_src.sh
$HOME/bin/clean_dist.sh
