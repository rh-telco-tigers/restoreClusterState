# restoreClusterState

These scripts are based on my blog post

https://myopenshiftblog.com/2021/04/07/backup-and-restore-of-etcd-cluster-state/

The section of this document is called "Restore of Previous Cluster State"

The scripts in this repo are numbered so it is intended that you either run the scripts or read the content in order.

Here is a high-level overview of how these scripts work.

1_getLeader.sh

  This script will get the name of the current etcd leader.  This leader will be where the backup and restore operations will run from.  The other 2 masters will be corrupted.

2_backup.txt

  This text document will tell you to run a backup of the cluster from the master server that was listed as the leader in step1.  Please ensure no other backups exist in /home/core/assets/backup
  After you run this backup, create a project called "thisprojectwilldisappear".  This purpose of this project is to prove that the backup will take us back to a time previous to when the backup was made.
  
3_moveMasterData.sh

  This script is to be copied (and run) on the non-leader master servers.  It basically makes the etcd and apiserver functions in-operable on these 2 servers.
  At this point, the OCP apiserver may become unresponsive or slow.  If this is the case, you may need to run some commands by SSHing directly (as core user) to the leader master server.
  
4_restore.txt

  The steps listed in this text document need to be run from the master leader.  As mentioned previously, ensure there are no other backups in /home/core/assets/backup directory
  The restore shell script will be run first followed by a restart of the kubelets on each of the masters.

5_force_etcd_update

  This script will force an etcd update/restore based on the version of the etcd database that was restored from backup.
  It will force a redeployment via the etcd operator, checks that all workloads are at latest revision and then exits
  Don't move on to next step until this script exits
  It is safe to exit the script and re-run but it may be best to comment out the patch section so that this part doesn't re-run
  Lastly, if any pods take a long time to update, delete that pod to force a redeployment
  In this case, the pods are in the openshift-etcd project and are called etcd-masterx......
  
6_force_kubeapi_update

  This script will force an kupeapi update/restore.
  It will force a redeployment via the kubeapi operator, checks that all workloads are at latest revision and then exits
  Don't move on to next step until this script exits
  It is safe to exit the script and re-run but it may be best to comment out the patch section so that this part doesn't re-run
  Lastly, if any pods take a long time to update, delete that pod to force a redeployment
  In this case, the pods are in the openshift-apiserver project and are called apiserver.  You may need to do an "oc get po -o wide" to get the correct pod.

7_force_kube_controllermanager_update

  This script will force an kubecontrollermanager update/restore.
  It will force a redeployment via the kubecontrollermanager operator, checks that all workloads are at latest revision and then exits
  Don't move on to next step until this script exits
  It is safe to exit the script and re-run but it may be best to comment out the patch section so that this part doesn't re-run
  Lastly, if any pods take a long time to update, delete that pod to force a redeployment
  In this case, the pods are in the openshift-controller-manager project and are called controller-manager.....  You may need to run an "oc get po -o wide" to     get the correct pod 


8_force_kube_scheduler

  This script will force an kubescheduler update/restore.
  It will force a redeployment via the kubescheduler operator, checks that all workloads are at latest revision and then exits
  Don't move on to next step until this script exits
  It is safe to exit the script and re-run but it may be best to comment out the patch section so that this part doesn't re-run
  Lastly, if any pods take a long time to update, delete that pod to force a redeployment
  In this case, the pods are in the openshift-kube-scheduler project and are called openshift-kube-scheduler-masterx......  

9_final_check.sh

  This is the final check to ensure that all etcd members are up
  
