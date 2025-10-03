#!/bin/bash
set -ex
/etc/eks/bootstrap.sh '${cluster_name}'  --container-runtime containerd --apiserver-endpoint '${eks_endpoint}' --b64-cluster-ca '${eks_ca}'
#  --kubelet-extra-args "--system-reserved cpu=50m,memory=0.2Gi,ephemeral-storage=1Gi"

