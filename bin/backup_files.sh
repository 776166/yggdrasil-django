#!/bin/sh
description='backup_files.sh — files backup advanced utility'

P1=`dirname $0`
HOME=`cd $P1; cd .. ; pwd`

. $HOME/etc/env.conf

#./clean

create_dist(){
    # filename='transfer_dist-files.zip'
    filename=`date +%Y%m%d-%H%M`'_dist-files.zip'
    filename=$HOME'/backups/'$filename
    # dir_to_store=$HOME/dist
    cd $HOME/dist && zip -ruyp9 $filename ./
    if [ -e $HOME'/backups/transfer_dist-files.zip' ]; then rm $HOME'/backups/transfer_dist-files.zip'; fi
    cp $filename $HOME'/backups/transfer_dist-files.zip'
}

create_transfer(){
    filename='transfer-files.zip'
    create
}

restore_transfer(){
    filename='transfer-files.zip'
    restore
}

restore_last(){
    filename='last-files.zip'
    restore
}

create_backup(){
    filename=`date +%Y%m%d-%H%M`'-files.zip'
    create
    if [ -e $HOME'/backups/last-files.zip' ]; then rm $HOME'/backups/last-files.zip'; fi
    cp $filename $HOME'/backups/last-files.zip'
}

create(){
    filename=$HOME'/backups/'$filename
    # echo $filename
    cd $HOME
    # echo $HOME
    # if [ -f $filename ]; then rm -v $filename; fi
    for i in site etc bin bot media; do
        echo '@'$i
        if [ -d "./$i" ]; then
            echo $i
            zip -ruyp $filename --exclude=`find ./$i -not -name "*.pyc" -print | grep -vi '\/\.junk*'`
        fi
    done
}

restore(){
    filename=$HOME'/backups/'$filename
    if [ -e $filename ]; then
        unzip $filename -d $HOME
    else
        echo 'No '$filename
    fi
}

help(){
    echo $description
    echo "Usage:    ./files [option]"
    echo ""
    echo "If no option is used, local backup and 'last-files' symlink will be create"
    echo "'--create-transfer'  Create transfer archive"
    #echo "'--restore-transfer' Restore transfer archive if exists"
    echo "'-d | --create-dist'  Create transfer archive"
    echo "'-l'|'--last'    Restore last local archive if exists"
    echo "'-h'|'--help'    Help"
}

if [ ! -z $1 ]; then
case $1 in
    '--create-transfer')    create_transfer
    ;;
#    '--restore-transfer')    restore_transfer
#    ;;
    '-l'|'--last')        restore_last
    ;;
    '-d'|'--dist')        create_dist
    ;;
    '-h'|'--help')        help
    ;;
    *)            help
    ;;
esac
else
    create_backup
fi
