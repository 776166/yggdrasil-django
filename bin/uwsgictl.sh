#!/bin/sh

usage_string='Usage: uwsgict start|stop|restart|status|grace|graceful'

export PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin/'

P1=`dirname $0`
HOME=`cd $P1; cd .. ; pwd`

. $HOME/etc/env.conf

CUSTOMER=`echo $HOME | cut -d'/' -f4`
DIST_NAME=`echo $HOME | cut -d'/' -f5`
CORRECT_UNIX_USER=`echo $HOME | cut -d'/' -f3`
ME=`whoami`

if [ $ME != $CORRECT_UNIX_USER ]; then
    echo 'Please run "'${0##*/}'" script ONLY under "'$CORRECT_UNIX_USER'" user. Not under "'$ME'" user.'
    exit 0
fi

pid_dir='/var/run/'$ME'/'
pid_file=$pid_dir'ui-'$CUSTOMER'-'$DIST_NAME'.uwsgi.pid'
script=$HOME'/bin/uwsgictl'
conf=$HOME'/etc/uwsgi.yaml'

if [ -z $1 ]; then
    echo $usage_string &&  exit
fi

status() {
if [ -e $pid_file ]; then
    PID=`cat $pid_file`
    if [ `ps ax | grep -i 'uwsgi' | grep $PID | wc -l` != 0 ]; then
        echo uwsgi is running with pid $PID
    else
        echo uwsgi is not running
    fi
else
    echo 'no pid. is it your first start?'
    ps -eo pid,ppid,args | grep -iv grep | grep -iv uwsgictl | grep --color -i uwsgi
fi
}

run_test() {
if [ `$script status | grep 'uwsgi is running with pid' | wc -l` = 1 ]; then
    running='yes'
else
    running='no'
fi
}

start(){
run_test
if [ $running = 'no' ]; then
    $HOME/$VENV/bin/uwsgi -y $conf --pidfile $pid_file
    sleep 1 && status
else
    echo 'uwsgi already running'
fi
}

stop() {
run_test
if [ $running = 'yes' ]; then
    echo 'stopping uwsgi'
    uwsgi --stop $pid_file
    sleep 1 && status
else
    echo 'uwsgi is not running'
fi
if [ -e $pid_file ]; then
    rm $pid_file
fi
}

grace(){
run_test
if [ $running = 'yes' ]; then
    uwsgi --reload $pid_file
    sleep 1 && status
else
    echo 'uwsgi is not running'
fi
}

case $1 in
    start)      start ;;
    stop)       stop ;;
    restart)    stop && start ;;
    status)     status;;
    grace)      grace;;
    graceful)   grace;;
esac
