#! /bin/bash

set -x

#This will force redeployment of kube-scheduler and check that everything is at same release

DATE=`date +%m%d%y%H%M%S`;

#oc patch kubescheduler/cluster  --patch '{"spec":{"forceRedeploymentReason": "recovery-'"$DATE"'"}}' --type=merge


echo "Waiting for Operator to Update Revision Number"

wait 60;

KUBESchedulerRevision=`oc describe kubescheduler cluster|grep "Latest Available Revision"|awk -F ":" '{print $2}'|tr -d ' '`;
NumberAtCurrentRevision=`oc describe kubescheduler cluster|grep "Current Revision"|grep -v $KUBESchedulerRevision | wc -l`;

echo $NumberAtCurrentRevision;

while [ $NumberAtCurrentRevision -ne 0 ]; do echo "Waiting for All Kube-Scheduler Pods to be at latest revision"; sleep 1; done;


