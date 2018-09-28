#!/bin/sh

P1=`dirname $0`
HOME=`cd $P1; cd .. ; pwd`

#$HOME/bin/prepare2publish
$HOME/bin/files.sh
$HOME/bin/pg.sh -b
