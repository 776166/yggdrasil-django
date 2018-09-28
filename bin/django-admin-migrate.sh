#!/bin/sh
# Run django-admin custom commands while publishing
# Deprecation candidate due to strict django mirgation policy

P1=`dirname $0`
HOME=`cd $P1; cd .. ; pwd`

. $HOME/etc/env.conf

MIGRATE_LIST='django-admin-migrate.txt'
LOGS=$HOME/log/django-admin-migrate.log

if [ -f $HOME/$DIR/$MIGRATE_LIST ]; then
    echo `date`' START' >> $LOGS
    for command in ` cat $HOME/$DIR/$MIGRATE_LIST|grep -vi ^#`; do
        echo "Command: "$command $command >> $LOGS 2>&1
        $HOME/$VENV/bin/python $HOME/site/manage.py $command >> $LOGS 2>&1
    done
    echo `date`' STOP' >> $LOGS
else
    echo "No file $HOME/$DIR/django-admin-migrate.txt"
fi
exit 0