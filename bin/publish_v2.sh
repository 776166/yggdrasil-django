#!/bin/sh
# Deprecate due to ansible
P1=`dirname $0`
HOME=`cd $P1; cd .. ; pwd`

. $HOME/etc/env.conf

if [ -z $PUBLISH_SERVER ] || [ -z $PUBLISH_PATH ]; then
    echo "Can not publish: PUBLISH_PATH or PUBLISH_SERVER in etc/env.conf not set"
    exit
fi

date=`date +%Y%m%d-%H%M`
files_file="transfer_dist-files.zip"
dbase_file="last-pgsql.gz"

### Prepare
find $HOME/$DIR -name '*.pyc' -print -delete
for i in last-files.zip last-pgsql.gz; do
    if [ -f $HOME/bin/backups/$i ]; then rm $HOME/bin/backups/$i; fi
done

$HOME/bin/prepare2publish_v2.sh
$HOME/bin/backup_files.sh -d
$HOME/bin/pg -b

### Copy to server
## Clean
for i in $files_file $dbase_file; do
    ssh $PUBLISH_USER@$PUBLISH_SERVER test -f $PUBLISH_PATH/tmp/$i
    if [ $? -eq 0 ]; then
        ssh $PUBLISH_USER@$PUBLISH_SERVER rm -v $PUBLISH_PATH/tmp/$i
    fi
done

scp $HOME/backups/$files_file $PUBLISH_USER@$PUBLISH_SERVER':'$PUBLISH_PATH'/tmp/'$files_file
scp $HOME/backups/last-pgsql.gz $PUBLISH_USER@$PUBLISH_SERVER':'$PUBLISH_PATH'/tmp/pgsql-transfer.gz'
ssh $PUBLISH_USER@$PUBLISH_SERVER cp $PUBLISH_PATH'/tmp/'$files_file $PUBLISH_PATH'/tmp/transfer_dist-files-'$date.zip
ssh $PUBLISH_USER@$PUBLISH_SERVER cp $PUBLISH_PATH'/tmp/pgsql-transfer.gz' $PUBLISH_PATH'/tmp/pgsql-transfer-'$date.gz

### Update Files
## Backup
ssh $PUBLISH_USER@$PUBLISH_SERVER $PUBLISH_PATH'/bin/backup'

## Clean
ssh $PUBLISH_USER@$PUBLISH_SERVER rm -r $PUBLISH_PATH'/tmp/dist'
ssh $PUBLISH_USER@$PUBLISH_SERVER mkdir $PUBLISH_PATH'/tmp/dist/'

ssh $PUBLISH_USER@$PUBLISH_SERVER unzip $PUBLISH_PATH'/tmp/'$files_file -d $PUBLISH_PATH'/tmp/dist'

# ssh $PUBLISH_USER@$PUBLISH_SERVER rm -r $PUBLISH_PATH'/site.dist'
ssh $PUBLISH_USER@$PUBLISH_SERVER rm -r $PUBLISH_PATH'/site'
ssh $PUBLISH_USER@$PUBLISH_SERVER mv $PUBLISH_PATH'/tmp/dist/site' $PUBLISH_PATH
# ssh $PUBLISH_USER@$PUBLISH_SERVER mv $PUBLISH_PATH'/site.dist' $PUBLISH_PATH'/site'

dir="bin"
for d in $dir; do
    ssh $PUBLISH_USER@$PUBLISH_SERVER cp -vfr $PUBLISH_PATH'/tmp/dist/'$d $PUBLISH_PATH
done

## Update pip
ssh $PUBLISH_USER@$PUBLISH_SERVER $PUBLISH_PATH'/'$VENV'/bin/pip install -r '$PUBLISH_PATH'/'$DIR'/pip-requirements.txt'

## Migrate Django
ssh $PUBLISH_USER@$PUBLISH_SERVER $PUBLISH_PATH'/bin/merge-migrations.sh'
ssh $PUBLISH_USER@$PUBLISH_SERVER $PUBLISH_PATH'/bin/migrate.sh'

## Custom migration through Django-admin
ssh $PUBLISH_USER@$PUBLISH_SERVER $PUBLISH_PATH'/bin/django-admin-migrate.sh'

## Relaunch UWSGI
ssh $PUBLISH_USER@$PUBLISH_SERVER $PUBLISH_PATH'/bin/uwsgictl grace'
