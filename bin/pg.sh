#!/bin/sh
# v 1.0

# restore_transfer_db(){
# if [ -e $HOME/backups/transfer-sql.gz ]; then
#  echo 'Restoring '$HOME'/backups/transfer-sql.gz'
#  zcat $HOME'/backups/transfer-sql.gz' | $HOME'/bin/mysql'
#  echo 'Done'
# fi
# exit
# }

backup(){
    echo 'Backuping to '$FILE
    pg_dump -d $DB -U $LOGIN > $FILE
    gzip -vf $FILE
    echo 'Done'
}

backup_db(){
    FILE=$HOME"/backups/"`date +%Y%m%d-%H%M`"-pgsql"
    backup
    cp $FILE'.gz' $HOME"/backups/last-pgsql.gz"
    exit
}

# create_transfer_db(){
# FILE=$HOME"/backups/transfer-pgsql"
# backup
# exit
# }

# create_db(){
# if [ -e /home/mad/.mysql_pass ]; then
#  mysql_pass=`cat /home/mad/.mysql_pass`
#  if [ `echo 'show databases;'| mysql -s -u root -p$mysql_pass | grep -v ^information_schema | grep -v performance_schema|grep ^$DB$|wc -l` = 0 ]; then
#  echo 'Creating DB..'
#  echo "create database "$DB" /*!40100 default character set UTF8*/;" | mysql -u root -p$mysql_pass
#  fi
#  echo 'Granting DB rights..'
#  echo "grant all on $DB.* to $LOGIN@localhost identified by '$PASS';" | mysql -u root -p$mysql_pass
# else
#  echo 'No /home/mad/.mysql_pass file. Can not install DB automatically.'
#  echo "create database "$DB" /*!40100 default character set UTF8*/;" | mysql -u root -p
#  echo "grant all on $DB.* to $LOGIN@localhost identified by '$PASS';" | mysql -u root -p
# fi
# exit 0
# }

# repare_db(){
# mysql_exec=$HOME"/bin/mysql"
# for table in `echo "show tables;" | $mysql_exec | grep -v "Tables_in"`; do
#  test=`echo "check table "$table | $mysql_exec | grep -v "status OK"`
#  test="asd"
#  if [ -z $test ]; then
#   echo "ok"
#   else
#   echo "repair table "$table | $mysql_exec | grep -v "Table"
#  fi
#   echo "analyze table "$table | $mysql_exec | grep -v "Table"
#   echo "optimize table  "$table | $mysql_exec | grep -v "Table"
# done
# exit 0
# }

P1=`dirname $0`
HOME=`cd $P1; cd .. ; pwd`

# if [ `uname -a | grep freebsd | wc -l` = '1' ]; then
# mysql='/usr/local/bin/mysql'
# else
# mysql='/usr/bin/mysql'
# fi

#settings=$HOME'/etc/settings_local.py'
# echo $HOME
passfile=$HOME'/.pgpass'
#export PGPASSFILE=$passfile

DB=`cat $passfile|cut -d':' -f3`
LOGIN=`cat $passfile|cut -d':' -f4`

# echo $DB $LOGIN
# exit 1
#DB=`cat $settings|grep 'NAME' | sed -e s/' '/''/g|sed -e s/','/''/g|cut -d':' -f2 | sed -e s/\'/''/g`
#LOGIN=`cat $settings | grep 'USER' | sed -e s/' '/''/g|sed -e s/','/''/g|cut -d':' -f2 | sed -e s/\'/''/g`
#PASS=`cat $settings | grep 'PASSWORD' | sed -e s/' '/''/g|sed -e s/','/''/g|cut -d':' -f2 | sed -e s/\'/''/g`

if [ ! -z $1 ]; then
	case $1 in
	# '-c'|'--create')	create_db
	# ;;
	# '-r'|'--repare')	repare_db
	# ;;
	# '--create-transfer')	create_transfer_db
	# ;;
	# '--restore-transfer')	restore_transfer_db
	# ;;
	'-b'|'--backup')	backup_db
	;;
	*)
	echo 'Usage: ./pg'
	echo '-b | --backup:	Backup DB'
	# echo '-r | --repare:	Repare and optimize DB'
	# echo '-c | --create:	Create DB'
	# echo '--create-transfer:  Create DB for transfer'
	# echo '--restore-transfer: Restore transfed DB'
	echo '-h | --help:	Help'
	exit
	;;
	esac
fi

export PGPASSFILE=$passfile
psql -d $DB -U $LOGIN -h localhost
