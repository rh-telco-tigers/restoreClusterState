#/bin/bash

# This script will show the leader of etcd.  This will be where the restore runs from.  We will want to move data off of other 2 masters next

#Get first etcd pod to run some commands
FirstETCD=`oc get po -n openshift-etcd|grep -v -e quorum -ve pruner|grep -v NAME|awk '{print $1}'|head -1`;

# Get leader info

#Check Status

oc exec -it $FirstETCD -n openshift-etcd -c etcdctl -- etcdctl endpoint health -w table
oc exec -it $FirstETCD -n openshift-etcd -c etcdctl -- etcdctl endpoint status -w table
