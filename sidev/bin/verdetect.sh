#!/bin/bash

if [ $# -eq 1 ]; then
    HOST=$1
else 
    HOST=10.10.88.126
fi

if [ "$DRILL_VER" == "" ]; then
  DRILL_VER=1.8.0
  DRILL_VER=$(python -c 'from xml.etree.ElementTree import ElementTree; print ElementTree(file="pom.xml").findtext("{http://maven.apache.org/POM/4.0.0}version")')
fi

echo "$DRILL_VER"

#scp distribution/target/apache-drill-$DRILL_VER.tar.gz root@$HOST:/opt/mapr/drill
#scp ~/bin/jardeploy.sh root@$HOST:/opt/mapr/drill
#ssh root@$HOST "chmod +x /opt/mapr/drill/jardeploy.sh"
#ssh root@$HOST "DRILL_VER=$DRILL_VER /opt/mapr/drill/jardeploy.sh"
