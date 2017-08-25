#!/bin/bash
if [ "$DRILL_VER" == "" ]; then
   DRILL_VER=1.9.0-SNAPSHOT
fi

STRIPPED_VER=${DRILL_VER/-*SNAPSHOT/}
DRILL_LOCATION=/opt/mapr/drill/drill-$STRIPPED_VER

DRILL_BUILD_NAME=apache-drill-$DRILL_VER
mkdir -p /opt/mapr/drill
cd /opt/mapr/drill
mkdir -p $DRILL_LOCATION

if [ -e $DRILL_LOCATION/bin/drillbit.sh ] ; then
  $DRILL_LOCATION/bin/drillbit.sh stop
fi

cp -f /tmp/$DRILL_BUILD_NAME.tar.gz /opt/mapr/drill/
tar -xzf $DRILL_BUILD_NAME.tar.gz
chown -R mapr:root $DRILL_BUILD_NAME

if [ -e drill-$DRILL_VER-debug ]; then
    rm -rf drill-$DRILL_VER-debug
fi

if [ -e $DRILL_LOCATION ]; then
    mkdir -p drill-$DRILL_VER-debug
    mv -f $DRILL_LOCATION drill-$DRILL_VER-debug
fi

mv $DRILL_BUILD_NAME $DRILL_LOCATION

if [ -e /opt/test/drill-override.conf ]; then
    cp -f /opt/test/drill-override.conf $DRILL_LOCATION/conf/
fi

if [ -e /opt/test/runbit ]; then
    cp -f /opt/test/runbit $DRILL_LOCATION/bin
fi

if [ -e /opt/test/logback.xml ]; then
    cp -f /opt/test/logback.xml $DRILL_LOCATION/conf/
fi

if [ -e /opt/test/drill-env.sh ]; then
    cp -f /opt/test/drill-env.sh $DRILL_LOCATION/conf/
fi

#copy jar files for maprdb format plugin
#cp -f /opt/test/drill-storage-maprdb-1.7.0-SNAPSHOT*.jar  $DRILL_LOCATION/jars

mkdir $DRILL_LOCATION/log
chown mapr:root $DRILL_LOCATION/log
chmod -R 777 $DRILL_LOCATION/log

#we should copy the client lib used in the system to drill

mkdir -p $DRILL_LOCATION/backup-maprjars

mv $DRILL_LOCATION/jars/3rdparty/mapr*.jar $DRILL_LOCATION/backup-maprjars

cp /opt/mapr/lib/maprfs*.jar $DRILL_LOCATION/jars/3rdparty/
cp /opt/mapr/lib/maprdb*.jar $DRILL_LOCATION/jars/3rdparty/
cp /opt/mapr/lib/mapr-hbase*.jar $DRILL_LOCATION/jars/3rdparty/

$DRILL_LOCATION/bin/drillbit.sh start
