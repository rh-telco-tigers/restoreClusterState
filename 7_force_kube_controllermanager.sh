#! /bin/bash

#set -x

#This will force redeployment of kube-controllermanager and check that everything is at same release

DATE=`date +%m%d%y%H%M%S`;

oc patch kubecontrollermanager/cluster  --patch '{"spec":{"forceRedeploymentReason": "recovery-'"$DATE"'"}}' --type=merge


echo "Waiting for Operator to Update Revision Number"

wait 60;

KUBEControllerRevision=`oc describe kubecontrollermanager cluster|grep "Latest Available Revision"|awk -F ":" '{print $2}'|tr -d ' '`;
NumberAtCurrentRevision=`oc describe kubecontrollermanager cluster|grep "Current Revision"|grep -v $KUBEControllerRevision | wc -l`;

echo $NumberAtCurrentRevision;

while [ $NumberAtCurrentRevision -ne 0 ]; do echo "Waiting for All Kube-Controller Pods to be at latest revision"; sleep 1; done;


