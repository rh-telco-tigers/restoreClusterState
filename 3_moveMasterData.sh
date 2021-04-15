#!/bin/bash

# This script will move certain directories to another location to cause only the leader/master to be available and for the restore to be run from it.
# This needs to be copied and made executable on the master nodes listed in output of the step 1
# Once this is run, some etcd and api services will stop running on these master nodes

sudo mv /etc/kubernetes/manifests/etcd-pod.yaml /tmp
sudo mv /etc/kubernetes/manifests/kube-apiserver-pod.yaml /tmp
sudo mv /var/lib/etcd /tmp

The API will most likely be unavailable until after step 4
