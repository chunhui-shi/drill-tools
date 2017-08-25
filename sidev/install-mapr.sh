#!/bin/bash
date
service mapr-warden stop

LOCAL_HOST=`LANG=c ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'`

echo "Install on local host $LOCAL_HOST !"

yum remove -y --disablerepo=* --enablerepo=MapRSI,MapRSI_Eco mapr-cldb mapr-kafka mapr-nfs mapr-webserver mapr-spark mapr-hbase mapr-resourcemanager mapr-nodemanager mapr-zookeeper mapr-zk-internal mapr-core mapr-hive mapr-hadoop-core mapr-mapreduce2 mapr-fileserver mapr-mapreduce1 mapr-core-internal mapr-gateway mapr-drill

yum clean all

yum install -y --disablerepo=* --enablerepo=MapRSI,MapRSI_Eco mapr-cldb mapr-kafka mapr-nfs mapr-webserver mapr-spark mapr-hbase mapr-resourcemanager mapr-nodemanager mapr-zookeeper mapr-zk-internal mapr-core mapr-hive mapr-hadoop-core mapr-mapreduce2 mapr-fileserver mapr-mapreduce1 mapr-core-internal mapr-gateway

/opt/mapr/server/configure.sh -N cluster_$(hostname) -C $LOCAL_HOST -Z $LOCAL_HOST -F /root/disk.list

sleep 60
hadoop fs -ls /
sleep 10

RET=`hadoop fs -ls /user 2>&1 | grep "No such"  | wc -l`
while [ "$RET" != "0" ]; do
  sleep 5
  RET=`hadoop fs -ls /user 2>&1 | grep "No such"  | wc -l`
done

hadoop fs -mkdir /user/root
hadoop fs -mkdir /user/shi
hadoop fs -chown shi:shi /user/shi

rm -f /opt/test/LatestDemoLicense-M7.txt
wget --user=maprqa --password=maprqa http://stage.mapr.com/license/LatestDemoLicense-M7.txt -O /opt/test/LatestDemoLicense-M7.txt
maprcli license add -license /opt/test/LatestDemoLicense-M7.txt  -is_file true
date
