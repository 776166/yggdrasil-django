#!/bin/sh
# Deprecation candidate due to ansible

P1=`dirname $0`
HOME=`cd $P1; cd .. ; pwd`

. $HOME/etc/env.conf

APT=$HOME/$DIR/apt-requirements.txt
echo $APT
PACKAGES=''
for a in `cat $APT | grep -vi ^#`; do
	PACKAGES=$PACKAGES' '$a
done
sudo apt-get -y install $PACKAGES
