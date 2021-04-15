#! /bin/bash

set -x

#This will force redeployment of kube-apiserver and check that everything is at same release

DATE=`date +%m%d%y%H%M%S`;

oc patch kubeapiserver/cluster  --patch '{"spec":{"forceRedeploymentReason": "recovery-'"$DATE"'"}}' --type=merge

KUBEAPIRevision=`oc describe kubeapiserver cluster|grep "Latest Available Revision"|awk -F ":" '{print $2}'|tr -d ' '`;
NumberAtCurrentRevision=`oc describe kubeapiserver cluster|grep "Current Revision"|grep -v $KUBEAPIRevision | wc -l`;

echo $NumberAtCurrentRevision;

while [ $NumberAtCurrentRevision -ne 0 ]; do echo "Waiting for All Kube-ApiServer Pods to be at latest revision"; sleep 1; done;


