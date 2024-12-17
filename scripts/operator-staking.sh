#!/usr/bin/env bash

set -e

source ./scripts/core.sh

get_node_info_short

echo "=> Register operator staking tx"
kubectl exec -it -n "$NAME" -c hermesnode deploy/hermesnode -- /kube-scripts/retry.sh /kube-scripts/operator-staking.sh
sleep 5
echo Operator staking tx registered
display_status
