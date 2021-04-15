#! /bin/bash

set -x

#This will force redeployment of etcd and check that everything is at same release

DATE=`date +%m%d%y%H%M%S`;

oc patch etcd/cluster  --patch '{"spec":{"forceRedeploymentReason": "recovery-'"$DATE"'"}}' --type=merge

echo "Waiting for Operator to Update Revision Number"

wait 60


ETCDRevision=`oc describe etcd cluster|grep "Latest Available Revision"|awk -F ":" '{print $2}'|tr -d ' '`;
NumberAtCurrentRevision=`oc describe etcd cluster|grep "Current Revision"|grep -v $ETCDRevision | wc -l`;

echo $NumberAtCurrentRevision;

while [ $NumberAtCurrentRevision -ne 0 ]; do echo "Waiting for All ETCD Pods to be at latest revision"; sleep 1; done;


