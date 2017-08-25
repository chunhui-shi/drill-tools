#!/bin/bash -x
if [ "$DRILL_VER" == "" ]; then
  DRILL_VER=1.6.0
fi

APACHE_DEST="/opt/mapr/drill/apache-drill-$DRILL_VER"
DRILL_DEST="/opt/mapr/drill/drill-$DRILL_VER"
rm -rf $APACHE_DEST
cd /opt/mapr/drill
tar -xzf $APACHE_DEST.tar.gz 
if [ ! -e $DRILL_DEST/jars-orig ]; then
    mkdir $DRILL_DEST/jars-orig
    cp -r $DRILL_DEST/jars/* $DRILL_DEST/jars-orig
    mv $DRILL_DEST/jars/drill-storage-maprdb*.jar $DRILL_DEST/jars-orig
fi

rm -rf $DRILL_DEST/jars
mv $APACHE_DEST/jars $DRILL_DEST
cp $DRILL_DEST/jars-orig/drill-storage-maprdb*.jar $DRILL_DEST/jars
$DRILL_DEST/bin/drillbit.sh restart

