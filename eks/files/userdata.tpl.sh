#!/bin/bash
set -ex
/etc/eks/bootstrap.sh '${cluster_name}' --container-runtime containerd
