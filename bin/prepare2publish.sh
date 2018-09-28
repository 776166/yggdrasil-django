#!/bin/sh

P1=`dirname $0`
HOME=`cd $P1; cd .. ; pwd`

. $HOME/etc/env.conf

APPLICATION=$DIR/$APP

P1=`dirname $0`
HOME=`cd $P1; cd .. ; pwd`

# echo "Preparing..."
version=`$HOME/$VENV/bin/python $HOME/$DIR/manage.py engine_version`

echo "LESSing..."
dirs='css/scss'
css=''
for _css in `cat $HOME/etc/css.min.conf|grep -vi ^#`; do
    css=$css' '$_css
done

for i in $css; do
    # if [ -f $HOME/$DIR/static-dev/css/$i.min.css ]; then rm $HOME/$DIR/static-dev/css/$i.min.css; fi
    if [ -f $HOME/$DIR/static-dev/css/src/$i.less ]; then
        lessc --clean-css $HOME/$DIR/static-dev/css/src/$i.less $HOME/$DIR/static-dev/css/$i.$version.min.css
    fi
done

echo "JSing..."
js=''
for _js in `cat $HOME/etc/js.min.conf|grep -vi ^#`; do
    js=$js' '$_js
done
for i in $js; do
    # if [ -f $HOME/$DIR/static-dev/js/$i.min.js ]; then rm $HOME/$DIR/static-dev/js/$i.min.js; fi
    if [ -f $HOME/$DIR/static-dev/js/src/$i.js ]; then
        uglifyjs $HOME/$DIR/static-dev/js/src/$i.js > $HOME/$DIR/static-dev/js/$i.$version.min.js
    fi
done

echo "Collect static..."
if [ -d $HOME/$DIR/$STATIC_DIST ]; then rm -r $HOME/$DIR/$STATIC_DIST; fi
$HOME/$VENV/bin/python $HOME/$DIR/manage.py collectstatic --noinput -v 0

echo "Clean static and dev..."
for i in $css; do
    if [ -f $HOME/$DIR/$STATIC_DIST/css/$i.less ]; then rm -v $HOME/$DIR/$STATIC_DIST/css/$i.less >> /dev/null; fi
    if [ -f $HOME/$DIR/static-dev/css/$i.$version.min.css ]; then rm -v $HOME/$DIR/static-dev/css/$i.$version.min.css >> /dev/null; fi
    if [ -d $HOME/$DIR/$STATIC_DIST/css/src/ ]; then rm -rv $HOME/$DIR/$STATIC_DIST/css/src/ >> /dev/null; fi
done

for i in $js; do
    if [ -f $HOME/$DIR/$STATIC_DIST/js/$i.js ]; then rm -v $HOME/$DIR/$STATIC_DIST/js/$i.js >> /dev/null; fi
    if [ -f $HOME/$DIR/static-dev/js/$i.$version.min.js ]; then rm -v $HOME/$DIR/static-dev/js/$i.$version.min.js >> /dev/null; fi
    if [ -d $HOME/$DIR/$STATIC_DIST/js/src ]; then rm -rv $HOME/$DIR/$STATIC_DIST/js/src/ >> /dev/null; fi
done

for i in $dirs; do
    if [ -d $HOME/$DIR/$STATIC_DIST/$i ]; then rm -rv $HOME/$DIR/$STATIC_DIST/$i >> /dev/null; fi
done

echo "PIPing..."
$HOME/$VENV/bin/pip freeze > $HOME/$DIR/pip-requirements.txt

$HOME/bin/clean_py.sh $DIR >> /dev/null
pyformat -r -i -j `nproc` --exclude "pip-requirements.txt" $HOME/site/*

echo "Making dist..."
if [ -d $HOME/dist/ ]; then
    rm -r $HOME/dist
    mkdir $HOME/dist/
else
    mkdir $HOME/dist/
fi

$HOME/bin/make_dist.sh
cp -rL $HOME/bin/dist $HOME/dist/bin
cp -r $HOME/$DIR $HOME/dist/

for i in $dirs2copy; do
    if [ -d $HOME/$i ]; then
        cp -r $HOME/$i $HOME/dist
    fi
done

###Cleaning...
echo "Cleaning dist..."
if [ -d $HOME/dist/$DIR/$STATIC_DEV ]; then
    rm -vr $HOME/dist/$DIR/$STATIC_DEV
fi

for i in $dirs2copy; do
    if [ -d $HOME/dist/$i ]; then
        find $HOME/dist/$i -type d -print | grep '\/\.[a-Az-Z0-9][^\/$]*$' | xargs rm -vr >> /dev/null
    fi
done

# for i in $dirs2clean; do
#     if [ -d $HOME/dist/$i ]; then
#         rm -r $HOME/dist/$i
#     fi
# done

$HOME/bin/clean_py.sh dist >> /dev/null
