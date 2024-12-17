#!/usr/bin/env bash

set -e

source ./scripts/core.sh

get_node_info_short

echo "=> Register operator chain"
kubectl exec -it -n "$NAME" -c hermesnode deploy/hermesnode -- /kube-scripts/retry.sh /kube-scripts/operator-register-chain.sh
sleep 5
echo Operator chain registered
display_status
