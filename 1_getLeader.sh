#/bin/bash

# This script will show the leader of etcd.  This will be where the restore runs from.  We will want to move data off of other 2 masters next

#Get first etcd pod to run some commands
FirstETCD=`oc get po -n openshift-etcd|grep -v -e quorum -ve pruner|grep -v NAME|awk '{print $1}'|head -1`;

# Get leader info

LeaderIP=`oc exec -it $FirstETCD -n openshift-etcd -c etcdctl -- etcdctl endpoint status json|awk -F "," '{print $1,$5}'|grep true|awk '{print $1}'|awk -F "https://" '{print $2}'|awk -F ":" '{print $1}'`;
LeaderName=`oc get po -n openshift-etcd -o wide|grep -v -e quorum -ve pruner|grep -v NAME|grep \$LeaderIP|awk '{print $1}'`
RemainingMasters=`oc get po -n openshift-etcd -o wide|grep -ve quorum -ve pruner -ve installer|grep -v NAME|grep -v \$LeaderIP|awk '{print $1}'|tr '\n' ' '`

echo "The leader is $LeaderName.  This is where the backup and restore will be run from"

echo "In step 2, we will run backup of cluster and create a new project.  See 2_backup.txt for more info"

echo "In step 3, let's copy the 3_moveMasterData.sh script to $RemainingMasters"
